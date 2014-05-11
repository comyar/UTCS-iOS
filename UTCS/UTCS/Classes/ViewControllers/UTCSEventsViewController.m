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

// Models
#import "UTCSEvent.h"
#import "UTCSEventsDataSource.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"
#import "UIButton+UTCSButton.h"
#import "UIImage+Cacheless.h"


#pragma mark - Constants

// Name of the service used by this view controller
static NSString * const serviceName                 = @"events";

// Name of the background image
static NSString * const backgroundImageName         = @"eventsBackground";

// Name of the blurred background image
static NSString * const backgroundBlurredImageName  = @"eventsBackground-blurred";


#pragma mark - UTCSEventsViewController Class Extension

@interface UTCSEventsViewController ()

@property (nonatomic) UTCSEventsDataSource                  *dataSource;

@property (nonatomic) NSString                              *currentFilter;

//
@property (nonatomic) IBActionSheet                         *filterActionSheet;

//
@property (nonatomic) UIButton                              *filterButton;

//
@property (nonatomic) NSArray                               *filterTypes;

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
        
        self.backgroundImageView.image          = [UIImage cacheless_imageNamed:backgroundImageName];
        self.backgroundBlurredImageView.image   = [UIImage cacheless_imageNamed:backgroundBlurredImageName];
        
        self.activeHeaderView = [[UTCSActiveHeaderView alloc]initWithFrame:self.tableView.bounds];
        ((UILabel *)self.activeHeaderView.shimmeringView.contentView).text = @"UTCS Events";
        self.activeHeaderView.subtitleLabel.text = @"What Starts Here Changes the World";
        
        self.filterTypes = @[@"All", @"Talks", @"Careers", @"Organizations"];
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
        UIButton *button = [UIButton bouncyButton];
        button.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
        button.center = CGPointMake(self.view.width - 33.0, 22.0);
        
        UIImage *image = [[UIImage imageNamed:@"filter"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.tintColor = [UIColor whiteColor];
        imageView.frame = button.bounds;
        [button addSubview:imageView];
        
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:self.filterButton];
    [self.view bringSubviewToFront:self.filterButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.eventDetailViewController = nil;
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.filterButton) {
        
        if (!self.filterActionSheet) {
            self.filterActionSheet = ({
                IBActionSheet *actionSheet = [[IBActionSheet alloc]initWithTitle:@"Filter Events by Type"
                                                                        delegate:self
                                                               cancelButtonTitle:@"Done"
                                                          destructiveButtonTitle:nil
                                                               otherButtonTitles:nil, nil];
                
                for (NSString *type in self.filterTypes) {
                    [actionSheet addButtonWithTitle:type];
                }
                
                [actionSheet setTitleBackgroundColor:[UIColor clearColor]];
                [actionSheet setTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
                [actionSheet setButtonBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
                [actionSheet setButtonTextColor:[UIColor blackColor]];
                [actionSheet setTitleTextColor:[UIColor darkGrayColor]];
                [actionSheet setButtonHighlightBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.05]];
                actionSheet;
            });
        }
        
        [self.filterActionSheet showInView:self.view];
    }
}

#pragma mark IBActionSheetDelegate Methods

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < [self.filterTypes count]) {
        NSString *filterType = self.filterTypes[buttonIndex];
        [self filterEventsWithType:filterType];
    }
}

#pragma mark Filtering

- (void)filterEventsWithType:(NSString *)type
{
    if (![type isEqualToString:self.currentFilter]) {
        NSDictionary *indexPaths = [self.dataSource filterEventsWithType:type];
        NSArray *addIndexPaths = indexPaths[UTCSEventsFilterAddName];
        NSArray *removeIndexPaths = indexPaths[UTCSEventsFilterRemoveName];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:removeIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView insertRowsAtIndexPaths:addIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        [self.tableView beginUpdates];
        
        [self.tableView endUpdates];
    }
    
    self.currentFilter = type;
}

#pragma mark Updating

- (void)update
{
    [self.activeHeaderView showActiveAnimation:YES];
    
    [self updateWithArgument:nil completion:^(BOOL success, BOOL cacheHit) {
        
        [self.activeHeaderView showActiveAnimation:NO];
        
        if([self.dataSource.data count] > 0) {
            [self.dataSource prepareFilter];
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
        
        if (success && !cacheHit) {
            [self.tableView reloadData];
        }
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

#pragma mark UTCSDataSourceDelegate Methods

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource
{
    return @{UTCSEventsDataSourceCacheKey: dataSource.data};
}


@end
