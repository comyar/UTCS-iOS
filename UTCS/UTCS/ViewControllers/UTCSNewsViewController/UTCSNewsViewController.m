//
//  UTCSNewsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsViewController.h"

// Constants
static NSString *cellIdentifier = @"UTCSNewsTableViewCell";


#pragma mark - UTCSNewsViewController Class Extension

@interface UTCSNewsViewController ()

//
@property (strong, nonatomic) NSArray   *newsStories;

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
    
    // Regist tableview cell class
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // Initialize refresh control
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = COLOR_GRAY;
    [self.refreshControl addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark Refresh Control

- (void)didRefresh:(UIRefreshControl *)refreshControl
{
    NSLog(@"Did refresh table view");
}

#pragma mark Updating News Articles

- (void)updateNewsArticles
{
    
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsStories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

@end
