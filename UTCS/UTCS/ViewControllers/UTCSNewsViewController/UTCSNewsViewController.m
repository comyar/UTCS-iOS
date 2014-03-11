//
//  UTCSNewsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsViewController.h"
#import "UTCSNewsDetailViewController.h"
#import "UTCSNewsStory.h"
#import "UIColor+UTCSColors.h"
#import "FBShimmeringView.h"
#import "UIView+Positioning.h"

// Constants
static NSString     *cellIdentifier = @"UTCSNewsTableViewCell";
const NSTimeInterval kMinTimeIntervalBetweenUpdates = 3600;
const NSTimeInterval kEarliestTimeIntervalForNews = INT32_MIN;


#pragma mark - UTCSNewsViewController Class Extension

@interface UTCSNewsViewController ()

//
@property (strong, nonatomic) FBShimmeringView              *shimmeringView;

//
@property (strong, nonatomic) UILabel                       *navigationTitleLabel;

//
@property (strong, nonatomic) NSArray                       *newsStories;

//
@property (strong, nonatomic) NSDate                        *updateDate;

//
@property (strong, nonatomic) NSDateFormatter               *dateFormatter;

//
@property (strong, nonatomic) UTCSNewsDetailViewController  *newsStorydetailViewController;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.title = @"News";
        _dateFormatter = ({
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            self.dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
            self.dateFormatter.dateFormat = @"MMMM d, yyyy";
            dateFormatter;
        });
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
    self.tableView.separatorColor = [UIColor utcsTableViewSeparatorColor];
    self.tableView.rowHeight = 90.0;
    
    // Register tableview cell class
    [self.tableView registerNib:[UINib nibWithNibName:@"UTCSNewsTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellIdentifier];
    
    // Initialize refresh control
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor utcsRefreshControlColor];
    [self.refreshControl addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventValueChanged];
    
    self.shimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, 0.5 * self.view.width, 60)];
    self.navigationTitleLabel = [[UILabel alloc]initWithFrame:self.shimmeringView.frame];
    self.navigationTitleLabel.text = @"News";
    self.navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];
    self.shimmeringView.contentView = self.navigationTitleLabel;
    self.navigationItem.titleView = self.shimmeringView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateNewStories];
}

#pragma mark Refresh Control

- (void)didRefresh:(UIRefreshControl *)refreshControl
{
    [self updateNewStories];
}

#pragma mark Updating News Articles

- (void)updateNewStories
{
    self.shimmeringView.shimmering = YES;
    if(self.updateDate && [[NSDate date]timeIntervalSinceDate:self.updateDate] < kMinTimeIntervalBetweenUpdates) {
        self.shimmeringView.shimmering = NO;
        [self.refreshControl endRefreshing];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_NEWSSTORY_CLASS];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:UTCSParseNewsStoryDate greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:kEarliestTimeIntervalForNews]];
    [query findObjectsInBackgroundWithBlock: ^ (NSArray *objects, NSError *error) {
        if(objects) {
            NSMutableArray *newStories = [NSMutableArray new];
            for(PFObject *object in objects) {
                UTCSNewsStory *newsStory = [UTCSNewsStory newsStoryWithParseObject:object];
                [newsStory initializeAttributedTextWithAttributes:@{UTCSNewsStoryDetailNormalFont: [UIFont fontWithName:@"HelveticaNeue" size:16],
                                                                    UTCSNewsStoryDetailNormalColor: [UIColor utcsDarkGrayColor],
                                                                    UTCSNewsStoryDetailBoldFont: [UIFont fontWithName:@"HelveticaNeue" size:16],
                                                                    UTCSNewsStoryDetailBoldColor: [UIColor blackColor]}];
                [newStories addObject:newsStory];
            }
            self.newsStories = [newStories sortedArrayUsingComparator: ^ NSComparisonResult(id obj1, id obj2) {
                UTCSNewsStory *story1 = (UTCSNewsStory *)obj1;
                UTCSNewsStory *story2 = (UTCSNewsStory *)obj2;
                return [story2.date compare:story1.date];
            }];
            self.updateDate = [NSDate date];
            [self.tableView reloadData];
        }
        self.shimmeringView.shimmering = NO;
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsStories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UTCSNewsStory *newsStory = self.newsStories[indexPath.row];
    cell.textLabel.text = newsStory.title;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:newsStory.date];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if(!self.newsStorydetailViewController) {
        self.newsStorydetailViewController = [UTCSNewsDetailViewController new];
    }
    self.newsStorydetailViewController.newsStory = self.newsStories[indexPath.row];
    [self.navigationController pushViewController:self.newsStorydetailViewController animated:YES];
}

@end
