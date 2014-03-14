//
//  UTCSEventsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsViewController.h"
#import "UTCSEventsTableViewCell.h"
#import "UTCSEventDetailViewController.h"
#import "UTCSEvent.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"
#import "FBShimmeringView.h"
#import "FRDLivelyButton.h"
#import "UTCSSideMenuViewController.h"

// Constants
static NSString *cellIdentifier = @"UTCSEventsTableViewCell";
const CGFloat kEventsTableViewCellHeight            = 75.0;
const NSTimeInterval kMinTimeIntervalBetweenEventUpdates = 3600;


#pragma mark - UTCSEventsViewController Class Extension

@interface UTCSEventsViewController ()

//
@property (strong, nonatomic) FBShimmeringView              *shimmeringView;

//
@property (strong, nonatomic) FRDLivelyButton               *menuButton;

//
@property (strong, nonatomic) UILabel                       *navigationTitleLabel;

//
@property (strong, nonatomic) NSArray                       *events;

//
@property (strong, nonatomic) NSDate                        *updateDate;

//
@property (strong, nonatomic) NSDateFormatter               *dayDateFormatter;

//
@property (strong, nonatomic) NSDateFormatter               *monthDateFormatter;

//
@property (strong, nonatomic) UISegmentedControl            *eventsSegementedControl;

//
@property (strong, nonatomic) UTCSEventDetailViewController *eventDetailViewController;

@end


#pragma mark - UTCSEventsViewController Implementation

@implementation UTCSEventsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.title = @"Events";
        self.dayDateFormatter = ({
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"d";
            dateFormatter;
        });
        
        self.monthDateFormatter = ({
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"MMM";
            dateFormatter;
        });
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:@"UTCSEventsTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellIdentifier];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor utcsTableViewSeparatorColor];
    
    // Initialize refresh control
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor utcsRefreshControlColor];
    [self.refreshControl addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventValueChanged];
    
    // Initialize segmented control
    
    self.eventsSegementedControl = [[UISegmentedControl alloc]initWithItems:@[@"All",@"Academic", @"Careers"]];
    self.eventsSegementedControl.tintColor = [UIColor utcsBurntOrangeColor];
    self.eventsSegementedControl.selectedSegmentIndex = 0;
//    [self.navigationController.navigationBar.topItem setTitleView:self.eventsSegementedControl];
    
    self.shimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, 0.5 * self.view.width, 60)];
    self.navigationTitleLabel = [[UILabel alloc]initWithFrame:self.shimmeringView.frame];
    self.navigationTitleLabel.text = @"Events";
    self.navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];
    self.shimmeringView.contentView = self.navigationTitleLabel;
    self.navigationItem.titleView = self.shimmeringView;
    
    self.menuButton = [[FRDLivelyButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [self.menuButton setOptions:@{kFRDLivelyButtonColor: [UIColor utcsBurntOrangeColor]}];
    [self.menuButton setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
    [self.menuButton addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.menuButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Update data
    [self updateEventData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.menuButton) {
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:UTCSSideMenuDisplayNotification
                                                                                            object:self]];
    }
}

#pragma mark Refresh Control

- (void)didRefresh:(UIRefreshControl *)refreshControl
{
    [self updateEventData];
}

- (void)updateEventData
{
    self.shimmeringView.shimmering = YES;
    if(self.updateDate && [[NSDate date]timeIntervalSinceDate:self.updateDate] < kMinTimeIntervalBetweenEventUpdates) {
        self.shimmeringView.shimmering = NO;
        [self.refreshControl endRefreshing];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_EVENT_CLASS];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:UTCSParseEventStartDate greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:0.0]];
    [query findObjectsInBackgroundWithBlock: ^ (NSArray *objects, NSError *error) {
        if(objects) {
            NSMutableArray *events = [NSMutableArray new];
            for(PFObject *object in objects) {
                UTCSEvent *event = [UTCSEvent eventWithParseObject:object];
                [event initializeAttributedDescriptionWithAttributes:@{UTCSEventDetailNormalFont: [UIFont fontWithName:@"HelveticaNeue-Light"
                                                                                                                  size:16],
                                                                       UTCSEventDetailNormalColor: [UIColor utcsDarkGrayColor],
                                                                       UTCSEventDetailBoldFont: [UIFont fontWithName:@"HelveticaNeue" size:16],
                                                                       UTCSEventDetailBoldColor: [UIColor blackColor]}];
                [events addObject:event];
            }
            self.events = [events sortedArrayUsingComparator: ^ NSComparisonResult(id obj1, id obj2) {
                UTCSEvent *event1 = (UTCSEvent *)obj1;
                UTCSEvent *event2 = (UTCSEvent *)obj2;
                return [event1.startDate compare:event2.startDate];
            }];
            self.updateDate = [NSDate date];
            [self.tableView reloadData];
        }
        self.shimmeringView.shimmering = NO;
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if(!self.eventDetailViewController) {
        self.eventDetailViewController = [UTCSEventDetailViewController new];
    }
    self.eventDetailViewController.event = self.events[indexPath.row];
    [self.navigationController pushViewController:self.eventDetailViewController animated:YES];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kEventsTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UTCSEvent *event = self.events[indexPath.row];
    cell.nameLabel.text = event.name;
    cell.dayLabel.text = [self.dayDateFormatter stringFromDate:event.startDate];
    cell.monthLabel.text = [[self.monthDateFormatter stringFromDate:event.startDate]uppercaseString];
//    cell.locationLabel.text = event.location;
    return cell;
}

@end