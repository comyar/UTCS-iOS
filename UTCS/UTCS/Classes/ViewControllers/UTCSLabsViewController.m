//
//  UTCSLabsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsViewController.h"
#import "UTCSMenuButton.h"
#import "MBProgressHUD.h"
#import "UTCSSSHManager.h"
#import "UIView+CZPositioning.h"
#import "UTCSLabsManager.h"
#import "UTCSLabMachine.h"
#import "UTCSLabsTableViewCell.h"
#import "UIImage+ImageEffects.h"


@interface UTCSLabsViewController ()
@property (nonatomic) UIImageView               *backgroundImageView;
@property (nonatomic) UTCSMenuButton            *menuButton;
@property (nonatomic) UITableView               *tableView;
@property (nonatomic) UISearchBar               *searchBar;
@property (nonatomic) UIButton                  *scrollToTopButton;
@property (nonatomic) UTCSLabsManager           *labsManager;
@property (nonatomic) NSArray                   *searchResults;
@end

@implementation UTCSLabsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.labsManager = [UTCSLabsManager new];
    
//        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 88.0, self.view.width, self.view.height - 108.0)
//                                                     style:UITableViewStylePlain];
//        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
//        self.tableView.backgroundColor = [UIColor clearColor];
//        self.tableView.rowHeight = 64.0;
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self.labsManager;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.allowsSelection = NO;
//        [self.view addSubview:self.tableView];
        
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.width, 64.0)];
        self.searchBar.placeholder = @"Unix Machine";
        self.searchBar.tintColor = [UIColor whiteColor];
        self.searchBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [self.view addSubview:self.searchBar];
        self.searchBar.showsScopeBar = YES;
        self.searchBar.scopeButtonTitles = @[@"Third Floor Lab", @"Basement Lab"];
        
        self.labsManager.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        self.labsManager.searchDisplayController.delegate = self;
        
        self.scrollToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.scrollToTopButton.frame = CGRectMake(0.0, 0.0, self.view.width, 44.0);
        self.scrollToTopButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [self.scrollToTopButton addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.scrollToTopButton];
        
        // Menu Button
        self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
        [self.view addSubview:self.menuButton];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.labsManager syncLabsWithCompletion:^(BOOL success) {
        if(success) {
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.backgroundImageView.image = [[UIImage imageNamed:@"labsBackground-blurred"]applyDarkEffect];
    [self.view insertSubview:self.backgroundImageView atIndex:0];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{

}

- (void)didTouchDownInsideButton:(UIButton *)button
{
    if(button == self.scrollToTopButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    } else {
        [self.labsManager.searchDisplayController setActive:NO animated:YES];
    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0.0, self.tableView.y + 44.0, self.tableView.width, self.tableView.height - 44.0);
    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0.0, self.tableView.y - 44.0, self.tableView.width, self.tableView.height + 44.0);
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *scope = self.searchBar.scopeButtonTitles[searchOption];
        self.searchResults = [self.labsManager searchLabsWithSearchString:self.searchBar.text scope:scope];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [controller.searchResultsTableView reloadData];
        });
        
    });
    
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if([searchString length] == 0) {
        self.searchResults = nil;
        return YES;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *scope = self.searchBar.scopeButtonTitles[self.searchBar.selectedScopeButtonIndex];
        self.searchResults = [self.labsManager searchLabsWithSearchString:searchString scope:scope];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [controller.searchResultsTableView reloadData];
        });
        
    });
    
    return NO;
}

#pragma mark Search Results

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 64.0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alpha = 0.0;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    self.tableView.alpha = 1.0;
    self.searchResults = nil;
}

- (UTCSLabsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSLabsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSLabsTableViewCell"];
    if(!cell) {
        cell = [[UTCSLabsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UTCSLabsTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    UTCSLabMachine *labMachine = self.searchResults[indexPath.row];
    cell.textLabel.text = labMachine.hostname;
    cell.detailTextLabel.text = labMachine.labName;
    cell.occupiedLabel.text = (labMachine.occupied)? @"Occupied" : @"Unoccupied";
    cell.indicatorColor = (labMachine.occupied)? [UIColor redColor] : [UIColor greenColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}


@end
