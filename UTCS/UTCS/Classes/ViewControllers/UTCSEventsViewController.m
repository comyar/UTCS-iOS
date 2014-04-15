//
//  UTCSEventsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// View controllers
#import "UTCSEventsViewController.h"
#import "UTCSEventDetailViewController.h"
#import "UTCSEventsFilterTableViewController.h"

// Views
#import "UTCSMenuButton.h"
#import "UTCSEventsHeaderView.h"
#import "UTCSBackgroundHeaderBlurTableView.h"

// Models
#import "UTCSEvent.h"
#import "UTCSEventsDataSource.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"


#pragma mark - Constants

// Name of the background image
static NSString * const backgroundImageName         = @"eventsBackground";

// Name of the blurred background image
static NSString * const backgroundBlurredImageName  = @"eventsBackground-blurred";


#pragma mark - UTCSEventsViewController Class Extension

@interface UTCSEventsViewController ()

//
@property (nonatomic) UTCSEventsDataSource                  *eventsDataSource;

//
@property (nonatomic, getter = hasUpdatedWithAppear) BOOL   updatedWithAppear;

// -----
// @name View controllers
// -----

//
@property (nonatomic) WYPopoverController                   *filterPopoverController;

//
@property (nonatomic) UTCSEventsFilterTableViewController   *filterTableViewController;

//
@property (nonatomic) UTCSEventDetailViewController         *eventDetailViewController;

// -----
// @name Views
// -----

//
@property (nonatomic) UTCSMenuButton                        *menuButton;

//
@property (nonatomic) UIButton                              *filterButton;

//
@property (nonatomic) UTCSEventsHeaderView                  *headerView;

//
@property (nonatomic) UTCSBackgroundHeaderBlurTableView     *backgroundHeaderBlurTableView;
 
@end


#pragma mark - UTCSEventsViewController Implementation

@implementation UTCSEventsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Events";
        self.eventsDataSource = [UTCSEventsDataSource new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background header blur table view
    self.backgroundHeaderBlurTableView = ({
        UTCSBackgroundHeaderBlurTableView *view = [[UTCSBackgroundHeaderBlurTableView alloc]initWithFrame:self.view.bounds];
        view.tableView.delegate     = self;
        view.tableView.dataSource   = self.eventsDataSource;
        view.backgroundImage        = [[UIImage imageNamed:backgroundImageName]tintedImageWithColor:[UIColor utcsImageTintColor]
                                                                                       blendingMode:kCGBlendModeOverlay];
        view.backgroundBlurredImage = [[UIImage imageNamed:backgroundBlurredImageName]tintedImageWithColor:[UIColor utcsImageTintColor]
                                                                                              blendingMode:kCGBlendModeOverlay];
        
        view;
    });
    
    // Header view
    self.headerView = [[UTCSEventsHeaderView alloc]initWithFrame:self.backgroundHeaderBlurTableView.header.bounds];
    
    // Filter button
    self.filterButton = ({
        UTCSButton *button = [[UTCSButton alloc]initWithFrame:CGRectMake(self.view.width - 66, 8, 64, 32)];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [[UIImage imageNamed:@"filter"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.center = CGPointMake(0.5 * button.width, 0.5 * button.height);
        imageView.tintColor = [UIColor whiteColor];
        [button addSubview:imageView];
        
        button;
    });
    
    // Menu Button
    self.menuButton = [UTCSMenuButton new];
    
    [self.backgroundHeaderBlurTableView.header addSubview:self.headerView];
    [self.view addSubview:self.backgroundHeaderBlurTableView];
    [self.view addSubview:self.filterButton];
    [self.view addSubview:self.menuButton];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.filterButton) {
        
        if(!self.filterTableViewController) {
            self.filterTableViewController = [UTCSEventsFilterTableViewController new];
            self.filterTableViewController.delegate = self;
            
            self.filterPopoverController = [[WYPopoverController alloc]initWithContentViewController:self.filterTableViewController];
            self.filterPopoverController.popoverContentSize = CGSizeMake(200.0, 220.0);
            self.filterPopoverController.theme = ({
                WYPopoverTheme *theme = [WYPopoverTheme theme];
                theme.overlayColor = [UIColor colorWithWhite:0.0 alpha:0.5];
                theme.innerStrokeColor = [UIColor clearColor];
                theme.outerStrokeColor = [UIColor clearColor];
                theme.fillTopColor = [UIColor colorWithWhite:1.0 alpha:0.95];
                theme.fillBottomColor = [UIColor colorWithWhite:1.0 alpha:.95];
                theme.innerShadowColor = [UIColor clearColor];
                theme.outerShadowColor = [UIColor clearColor];
                theme.tintColor = [UIColor clearColor];
                theme.glossShadowColor = [UIColor clearColor];
                theme;
            });
            self.filterPopoverController.delegate = self;
        }
        [self.filterPopoverController presentPopoverFromRect:self.filterButton.frame
                                                      inView:self.view
                                    permittedArrowDirections:WYPopoverArrowDirectionUp
                                                    animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.updatedWithAppear) {
        [self update];
    }
}

- (void)update
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.headerView.downArrowImageView.alpha = 0.0;
    }];
    
    self.headerView.shimmeringView.shimmering = YES;
    [self.headerView.activityIndicatorView startAnimating];
    
    [self.eventsDataSource updateEventsWithCompletion:^{
        
        self.headerView.shimmeringView.shimmering = NO;
        [self.headerView.activityIndicatorView stopAnimating];
        
        if([self.eventsDataSource.filteredEvents count] > 0) {
            self.updatedWithAppear = YES;
            NSString *updateString = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterLongStyle
                                                                    timeStyle:NSDateFormatterMediumStyle];
            self.headerView.updatedLabel.text = [NSString stringWithFormat:@"Updated %@", updateString];
            [self.backgroundHeaderBlurTableView.tableView reloadData];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.headerView.updatedLabel.alpha          = 1.0;
            self.headerView.downArrowImageView.alpha    = ([self.eventsDataSource.filteredEvents count])? 1.0 : 0.0;
        }];
        
    }];
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEvent *event = self.eventsDataSource.filteredEvents[indexPath.row];
    
    // Estimate height of a news story title
    CGRect rect = [event.name boundingRectWithSize:CGSizeMake(self.backgroundHeaderBlurTableView.tableView.width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                                context:nil];
    
    return MIN(ceilf(rect.size.height), 128.0) + 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    UTCSEvent *event = self.eventsDataSource.filteredEvents[indexPath.row];
    self.eventDetailViewController = [UTCSEventDetailViewController new];
    self.eventDetailViewController.event = event;
    [self.navigationController pushViewController:self.eventDetailViewController animated:YES];
}

#pragma mark UTCSEventsFilterTableViewControllerDelegate Methods

- (void)eventsFilterTableViewController:(UTCSEventsFilterTableViewController *)eventsFilterTableViewController didSelectFilter:(NSString *)filter
{
    [self.eventsDataSource filterEventsWithTag:filter];
    [self.filterPopoverController dismissPopoverAnimated:YES];
    [self.backgroundHeaderBlurTableView.tableView reloadData];
}


@end
