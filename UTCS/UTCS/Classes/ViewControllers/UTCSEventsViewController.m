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
#import "UTCSEventsDetailViewController.h"
#import "UTCSStarredEventsViewController.h"

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

//
@property (nonatomic) UTCSEventsDataSource                  *dataSource;

//
@property (nonatomic) NSString                              *currentFilter;

//
@property (nonatomic) UISegmentedControl                    *filterSegmentedControl;

//
@property (nonatomic) NSArray                               *filterTypes;

//
@property (nonatomic) NSDictionary                          *filterTypeColors;

//
@property (nonatomic) UIImageView                           *filterButtonImageView;

//
@property (nonatomic) UIButton                              *starListButton;

//
@property (nonatomic) UTCSStarredEventsViewController       *starredEventsViewController;

//
@property (nonatomic) UTCSEventsDetailViewController        *eventDetailViewController;

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
        self.dataSource.delegate        = self;
        self.tableView.dataSource       = (UTCSEventsDataSource *)self.dataSource;
        self.tableView.delegate         = self;
        
        self.backgroundImageView.image          = [UIImage cacheless_imageNamed:backgroundImageName];
        self.backgroundBlurredImageView.image   = [UIImage cacheless_imageNamed:backgroundBlurredImageName];
        
        self.activeHeaderView = [[UTCSActiveHeaderView alloc]initWithFrame:self.tableView.bounds];
        ((UILabel *)self.activeHeaderView.shimmeringView.contentView).text = @"UTCS Events";
        self.activeHeaderView.subtitleLabel.text = @"What Starts Here Changes the World";
        
        self.filterTypes = @[@"All", @"Talks", @"Careers", @"Orgs"];
        self.filterTypeColors = @{@"All":[UIColor whiteColor],
                                  @"Talks":[UIColor utcsEventTalkColor],
                                  @"Careers":[UIColor utcsEventCareersColor],
                                  @"Orgs":[UIColor utcsEventStudentOrgsColor]};
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
    
    self.starListButton = ({
        UIButton *button = [UIButton bouncyButton];
        button.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
        button.center = CGPointMake(self.view.width - 33.0, 22.0);
        
        UIImage *image = [[UIImage imageNamed:@"starlist"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.tintColor = [UIColor whiteColor];
        imageView.frame = button.bounds;
        [button addSubview:imageView];
        
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:self.starListButton];
    [self.view bringSubviewToFront:self.starListButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.eventDetailViewController = nil;
}

#pragma mark Controls

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.starListButton) {
        if (!self.starredEventsViewController) {
            self.starredEventsViewController = [UTCSStarredEventsViewController new];
            self.starredEventsViewController.backgroundImageView.image = self.backgroundBlurredImageView.image;
            self.starredEventsViewController.delegate = self;
        }
        [self.navigationController presentViewController:self.starredEventsViewController animated:YES completion:nil];
    }
}

- (void)didChangeValueForControl:(UIControl *)control
{
    if (control == self.filterSegmentedControl) {
        NSInteger index = self.filterSegmentedControl.selectedSegmentIndex;
        NSString *filterType = self.filterTypes[index];
        [self filterEventsWithType:filterType];
        self.filterSegmentedControl.tintColor = self.filterTypeColors[filterType];
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
        [self.tableView deleteRowsAtIndexPaths:removeIndexPaths withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView insertRowsAtIndexPaths:addIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    }
    
    self.currentFilter = type;
}

#pragma mark Updating

- (void)update
{
    if ([self.dataSource shouldUpdate]) {
        [self.activeHeaderView showActiveAnimation:YES];
        
        [self.dataSource updateWithArgument:nil completion:^(BOOL success, BOOL cacheHit) {
            
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
}

#pragma mark UTCSStarredEventsViewControllerDelegate Methods

- (void)starredEventsViewController:(UTCSStarredEventsViewController *)starredEventsViewController didSelectEvent:(UTCSEvent *)event
{
    if (!self.eventDetailViewController) {
        self.eventDetailViewController = [UTCSEventsDetailViewController new];
    }
    self.eventDetailViewController.event = event;
    [self.navigationController pushViewController:self.eventDetailViewController animated:YES];
}

#pragma mark UITableViewDelegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (!self.filterSegmentedControl) {
            self.filterSegmentedControl = ({
                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:self.filterTypes];
                segmentedControl.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
                [segmentedControl addTarget:self action:@selector(didChangeValueForControl:) forControlEvents:UIControlEventValueChanged];
                segmentedControl.frame = CGRectMake(8.0, 8.0, self.view.width - 16.0, 32.0);
                segmentedControl.tintColor = [UIColor whiteColor];
                segmentedControl.selectedSegmentIndex = 0;
                segmentedControl.layer.cornerRadius = 4.0;
                segmentedControl.layer.masksToBounds = YES;
                segmentedControl;
            });
        }
        
        return ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 32.0)];
            [view addSubview:self.filterSegmentedControl];
            view;
        });
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 48.0;
    }
    return 0.0;
}

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
        self.eventDetailViewController = [UTCSEventsDetailViewController new];
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
