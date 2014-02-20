//
//  UTCSEventsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsViewController.h"

// Constants
static NSString *cellIdentifier = @"UTCSEventsTableViewCell";

#pragma mark - UTCSEventsViewController Class Extension

@interface UTCSEventsViewController ()

//
@property (strong, nonatomic) NSArray   *events;

@end


#pragma mark - UTCSEventsViewController Implementation

@implementation UTCSEventsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.title = @"Events";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Adjust edges so tableview extends beneath navigation bar
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.navigationController.navigationBar.bounds) + CGRectGetHeight([[UIApplication sharedApplication]statusBarFrame]) + 1, 0, 0, 0); // plus one accounts for navigation bar hairline
    
    // Register tableview cell class
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // Initialize refresh control
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = COLOR_GRAY;
    [self.refreshControl addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventValueChanged];
    
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
    PFQuery *query = [PFQuery queryWithClassName:PARSE_EVENT_CLASS];
    [query whereKey:PARSE_EVENT_DATE_END greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:-3000000]];
    [query findObjectsInBackgroundWithBlock: ^ (NSArray *objects, NSError *error) {
        if(objects) {
            self.events = [objects sortedArrayUsingComparator: ^ NSComparisonResult(id obj1, id obj2) {
                PFObject *p_obj1 = (PFObject *)obj1;
                PFObject *p_obj2 = (PFObject *)obj2;
                if(p_obj1[PARSE_EVENT_DATE_END] > p_obj2[PARSE_EVENT_DATE_END]) {
                    return NSOrderedAscending;
                } else if(p_obj1[PARSE_EVENT_DATE_END] < p_obj2[PARSE_EVENT_DATE_END]) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
            }];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.description);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.events[indexPath.row][PARSE_EVENT_NAME];
    return cell;
}

@end
