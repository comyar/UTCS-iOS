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
#import "UIColor+UTCSColors.h"

// Constants
static NSString *cellIdentifier = @"UTCSEventsTableViewCell";
const CGFloat kEventsTableViewCellHeight            = 75.0;
const NSTimeInterval kMinTimeIntervalBetweenUpdates = 3600;


#pragma mark - UTCSEventsViewController Class Extension

@interface UTCSEventsViewController ()

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
        [self updateEventData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Adjust edges so tableview extends beneath navigation bar
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Configure table view
    [self.tableView registerNib:[UINib nibWithNibName:@"UTCSEventsTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellIdentifier];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.navigationController.navigationBar.bounds) + CGRectGetHeight([[UIApplication sharedApplication]statusBarFrame]) + 1, 0, 0, 0); // plus one accounts for navigation bar hairline
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
    
    // Update data
    [self updateEventData];
}

#pragma mark Refresh Control

- (void)didRefresh:(UIRefreshControl *)refreshControl
{
    [self updateEventData];
}

- (void)updateEventData
{
    if(self.updateDate && [[NSDate date]timeIntervalSinceDate:self.updateDate] < kMinTimeIntervalBetweenUpdates) {
        [self.refreshControl endRefreshing];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_EVENT_CLASS];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:PARSE_EVENT_DATE_END greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:-3000000]];
    [query findObjectsInBackgroundWithBlock: ^ (NSArray *objects, NSError *error) {
        if(objects) {
            self.events = objects;
            self.events = [self.events sortedArrayUsingComparator: ^ NSComparisonResult(id obj1, id obj2) {
                PFObject *p_obj1 = (PFObject *)obj1;
                PFObject *p_obj2 = (PFObject *)obj2;
                if(p_obj1[PARSE_EVENT_DATE_START] > p_obj2[PARSE_EVENT_DATE_START]) {
                    return NSOrderedAscending;
                } else if(p_obj1[PARSE_EVENT_DATE_START] < p_obj2[PARSE_EVENT_DATE_START]) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
            }];
            self.updateDate = [NSDate date];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.description);
        }
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
    cell.nameLabel.text = self.events[indexPath.row][PARSE_EVENT_NAME];
    cell.dayLabel.text = [self.dayDateFormatter stringFromDate:self.events[indexPath.row][PARSE_EVENT_DATE_START]];
    cell.monthLabel.text = [self.monthDateFormatter stringFromDate:self.events[indexPath.row][PARSE_EVENT_DATE_START]];
    cell.locationLabel.text = self.events[indexPath.row][PARSE_EVENT_LOCATION];
    return cell;
}

@end
