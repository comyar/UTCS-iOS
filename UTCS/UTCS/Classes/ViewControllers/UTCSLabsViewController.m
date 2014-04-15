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
#import "UTCSLabsDataSource.h"
#import "UTCSLabMachine.h"
#import "UTCSLabsTableViewCell.h"
#import "UIImage+ImageEffects.h"
#import "UTCSLabView.h"

@interface UTCSLabsViewController ()
@property (nonatomic) UIImageView               *backgroundImageView;
@property (nonatomic) UTCSMenuButton            *menuButton;
@property (nonatomic) UISearchBar               *searchBar;
@property (nonatomic) UIButton                  *scrollToTopButton;
@property (nonatomic) UTCSLabsDataSource        *labsDataSource;
@property (nonatomic) NSArray                   *searchResults;
@property (nonatomic) UIScrollView              *scrollView;
@property (nonatomic) UTCSLabView               *thirdFloorLabView;

@end

@implementation UTCSLabsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.labsDataSource = [UTCSLabsDataSource new];
        
        
        self.scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 108.0, self.view.width, self.view.height - 108.0)];
            scrollView.pagingEnabled = YES;
            scrollView.alwaysBounceHorizontal = YES;
            scrollView;
        });
        [self.view addSubview:self.scrollView];
        
        self.thirdFloorLabView = ({
            UTCSLabView *labView = [[UTCSLabView alloc]initWithFrame:self.scrollView.bounds];
            labView.tag = UTCSThirdFloorLab;
            labView.dataSource = self.labsDataSource;
            labView;
        });
        [self.scrollView addSubview:self.thirdFloorLabView];

        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.width, 64.0)];
        self.searchBar.placeholder = @"Unix Machine";
        self.searchBar.tintColor = [UIColor whiteColor];
        self.searchBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [self.view addSubview:self.searchBar];
        self.searchBar.showsScopeBar = YES;
        self.searchBar.scopeButtonTitles = @[@"Third Floor Lab", @"Basement Lab"];
        
        self.labsDataSource.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        self.labsDataSource.searchDisplayController.delegate = self;
        
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
    [self.labsDataSource syncLabsWithCompletion:^(BOOL success) {
        
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
//        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    } else {
        [self.labsDataSource.searchDisplayController setActive:NO animated:YES];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *scope = self.searchBar.scopeButtonTitles[searchOption];
        self.searchResults = [self.labsDataSource searchLabsWithSearchString:self.searchBar.text scope:scope];
        
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
        self.searchResults = [self.labsDataSource searchLabsWithSearchString:searchString scope:scope];
        
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
    self.scrollView.alpha = 0.0;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    self.scrollView.alpha = 1.0;
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
