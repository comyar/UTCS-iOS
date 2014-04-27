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

#import "IBActionSheet.h"

// Models
#import "UTCSEvent.h"
#import "UTCSEventsDataSource.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"


#pragma mark - Constants

// Name of the service used by this view controller
static NSString * const serviceName                 = @"events";

// Duration of animations performed by this view controller
static const CGFloat animationDuration              = 0.3;

// Name of the background image
static NSString * const backgroundImageName         = @"eventsBackground";

// Name of the blurred background image
static NSString * const backgroundBlurredImageName  = @"eventsBackground-blurred";


#pragma mark - UTCSEventsViewController Class Extension

@interface UTCSEventsViewController ()

//
@property (nonatomic) UIButton                              *filterButton;

//
//@property (nonatomic) UTCSEventsFilterViewController        *eventsFilterViewController;
//
@property (nonatomic) UTCSEventDetailViewController         *eventDetailViewController;

@end


#pragma mark - UTCSEventsViewController Implementation

@implementation UTCSEventsViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if(self = [super initWithStyle:style]) {
        self.dataSource                 = [[UTCSEventsDataSource alloc]initWithService:serviceName];
        self.tableView.dataSource       = (UTCSEventsDataSource *)self.dataSource;
        self.tableView.delegate         = self;
        
        self.backgroundImageView.image          = [UIImage imageNamed:backgroundImageName];
        self.backgroundBlurredImageView.image   = [UIImage imageNamed:backgroundBlurredImageName];
        
        self.activeHeaderView = [[UTCSActiveHeaderView alloc]initWithFrame:self.tableView.bounds];
        ((UILabel *)self.activeHeaderView.shimmeringView.contentView).text = @"UTCS Events";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filterButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame = CGRectMake(self.view.width - 48.0, 4.0, 36.0, 36.0);
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:self.filterButton];
    [self.view bringSubviewToFront:self.filterButton];
    
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.filterButton) {
        IBActionSheet *actionSheet = [[IBActionSheet alloc]initWithTitle:@"Filter Events" delegate:nil cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:@"All", @"Careers", @"Talks", @"Student Orgs", nil];
        [actionSheet setTitleBackgroundColor:[UIColor clearColor]];
        
        [actionSheet setTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        [actionSheet setButtonBackgroundColor:[UIColor colorWithWhite:0.75 alpha:0.95]];
        [actionSheet setButtonTextColor:[UIColor whiteColor]];
        [actionSheet setTitleTextColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        [actionSheet setButtonHighlightBackgroundColor:[UIColor colorWithWhite:0.75 alpha:0.25]];
        [actionSheet showInView:self.view];
    }
}

#pragma mark Updating

- (void)update
{
    [self.activeHeaderView showActiveAnimation:YES];
    
    [self updateWithArgument:nil completion:^(BOOL success) {
        
        [self.activeHeaderView showActiveAnimation:NO];
        
        if([self.dataSource.data count] > 0) {
            NSString *updateString = [NSDateFormatter localizedStringFromDate:self.dataSource.updated
                                                                    dateStyle:NSDateFormatterLongStyle
                                                                    timeStyle:NSDateFormatterMediumStyle];
            self.activeHeaderView.updatedLabel.text = [NSString stringWithFormat:@"Updated %@", updateString];
        } else {
            
            if (!success) {
                // Show frowny face
            }
            
            self.activeHeaderView.updatedLabel.text = @"No Events Available";
        }
        
        [self.tableView reloadData];
        
    }];
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEvent *event = self.dataSource.data[indexPath.row];
    
    // Estimate height of event name
    CGRect rect = [event.name boundingRectWithSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                                context:nil];
    
    return MIN(ceilf(rect.size.height), 128.0) + 50.0;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UTCSEvent *event = self.dataSource.data[indexPath.row];
    if (!self.eventDetailViewController) {
        self.eventDetailViewController = [UTCSEventDetailViewController new];
    }
    self.eventDetailViewController.event = event;
    [self.navigationController pushViewController:self.eventDetailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.alpha = 0.5;
    [UIView animateWithDuration:animationDuration animations:^{
        cell.contentView.alpha = 1.0;
    }];
}


@end
