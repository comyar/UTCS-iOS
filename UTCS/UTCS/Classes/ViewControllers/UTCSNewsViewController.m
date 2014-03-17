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
#import "UIView+CZPositioning.h"
#import "FBShimmeringView.h"
#import "FRDLivelyButton.h"
#import "UTCSSideMenuViewController.h"
#import "UTCSNewsStoryManager.h"

// Constants
static NSString * const cellIdentifier              = @"UTCSNewsTableViewCell";
const NSTimeInterval kMinTimeIntervalBetweenUpdates = 3600;



#pragma mark - UTCSNewsViewController Class Extension

@interface UTCSNewsViewController ()

//
@property (assign, nonatomic) BOOL hasAppeared;

//
@property (strong, nonatomic) FBShimmeringView              *shimmeringView;

//
@property (strong, nonatomic) FRDLivelyButton               *menuButton;

//
@property (strong, nonatomic) UILabel                       *navigationTitleLabel;

//
@property (strong, nonatomic) NSArray                       *newsStories;

//
@property (strong, nonatomic) NSDate                        *updateDate;

//
@property (strong, nonatomic) UTCSNewsDetailViewController  *newsStorydetailViewController;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.title = @"News";
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
    self.tableView.rowHeight = 90;
    
    // Register tableview cell class
    [self.tableView registerNib:[UINib nibWithNibName:@"UTCSNewsTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellIdentifier];
    
    // Initialize refresh control
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor utcsRefreshControlColor];
    [self.refreshControl addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventValueChanged];
    
    self.shimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, 0.5 * self.view.width, 60)];
    self.navigationTitleLabel = [[UILabel alloc]initWithFrame:self.shimmeringView.frame];
    self.navigationTitleLabel.text = self.title;
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
    if(!self.hasAppeared) {
        self.hasAppeared = YES;
        [self updateNewStories];
    }
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
    [self updateNewStories];
}

#pragma mark Updating News Stories

- (void)updateNewStories
{
    self.shimmeringView.shimmering = YES;
    if(self.updateDate && [[NSDate date]timeIntervalSinceDate:self.updateDate] < kMinTimeIntervalBetweenUpdates) {
        self.shimmeringView.shimmering = NO;
        [self.refreshControl endRefreshing];
        return;
    }
    
    [UTCSNewsStoryManager newsStoriesWithFontAttributes:[self newsStoryFontAttributes] completion: ^ (NSArray *newsStories, NSError *error) {
        if(newsStories) {
            self.newsStories = newsStories;
        }
        self.shimmeringView.shimmering = NO;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (NSDictionary *)newsStoryFontAttributes
{
    return @{UTCSNewsStoryTitleFontAttribute:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
             UTCSNewsStoryTitleFontColorAttribute:[UIColor blackColor],
             UTCSNewsStoryDateFontAttribute:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1],
             UTCSNewsStoryDateFontColorAttribute:[UIColor utcsBurntOrangeColor],
             UTCSNewsStoryTextFontAttribute:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
             UTCSNewsStoryTextFontColorAttribute:[UIColor utcsDarkGrayColor],
             UTCSNewsStoryParagraphLineSpacing:@(4.0)};
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
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:newsStory.date
                                                               dateStyle:NSDateFormatterLongStyle
                                                               timeStyle:NSDateFormatterNoStyle];
    return cell;
}

#pragma mark UITableViewDelegate Methods

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
