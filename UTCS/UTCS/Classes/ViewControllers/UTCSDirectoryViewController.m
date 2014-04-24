//
//  UTCSDirectoryViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UTCSDirectoryViewController.h"
#import "UTCSDirectoryDataSource.h"
#import "UTCSDirectoryPerson.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+CZTinting.h"
#import "MBProgressHUD.h"
#import "UTCSDirectoryTableViewCell.h"
#import "UTCSDirectoryDataSourceSearchController.h"


#pragma mark - Constants
// Key used to cache directory
static NSString *directoryCacheKey = @"directory";

// Key used to cache flat directory
static NSString *flatDirectoryCacheKey = @"flatDirectory";


#pragma mark - UTCSDirectoryViewController Class Extension

@interface UTCSDirectoryViewController ()

@property (nonatomic) NSIndexPath               *selectedIndexPath;

// Search bar
@property (nonatomic) UISearchBar               *searchBar;

@property (nonatomic) UIButton                  *searchButton;

@property (nonatomic) UISearchDisplayController *directorySearchDisplayController;
@end


#pragma mark - UTCSDirectoryViewController Implementation

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        
        self.dataSource = [[UTCSDirectoryDataSource alloc]initWithService:@"directory"];
        self.tableView.dataSource = (UTCSDirectoryDataSource *)self.dataSource;
        self.backgroundImageView.image = [UIImage imageNamed:@"directoryBackground"];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.sectionIndexColor = [UIColor whiteColor];
        
        self.searchBar = ({
            UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 64.0)];
            searchBar.backgroundImage = [UIImage new];
            searchBar.tintColor = [UIColor utcsBurntOrangeColor];
            searchBar.placeholder = @"Search Directory";
            searchBar.scopeButtonTitles = @[@"All", @"Faculty", @"Staff", @"Graduate"];
            searchBar.scopeBarBackgroundImage = [UIImage new];
            searchBar.tintColor = [UIColor whiteColor];
            [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarBackground"] forState:UIControlStateNormal];
            searchBar;
        });
        self.tableView.tableHeaderView = self.searchBar;
        self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        self.directorySearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        self.directorySearchDisplayController.searchResultsDataSource = self.dataSource.searchController;
        self.directorySearchDisplayController.searchResultsDelegate = self;
        self.directorySearchDisplayController.delegate = self;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.height);
    [self update];
}

- (void)update
{
    if ([self.dataSource shouldUpdate]) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = @"Syncing Directory";
        
        [self updateWithArgument:nil completion:^(BOOL success) {
            
            if (success) {
                [((UTCSDirectoryDataSource *)self.dataSource) buildFlatDirectory];
                [self.tableView reloadData];
                self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.height);
            } else {
                NSLog(@"directory failed");
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

#pragma mark UITableViewDelegate Methpds

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSDirectoryTableViewCell *previous = (UTCSDirectoryTableViewCell *)[tableView cellForRowAtIndexPath:self.selectedIndexPath];
    UTCSDirectoryTableViewCell *cell = (UTCSDirectoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
        self.selectedIndexPath = nil;
        cell.showDetails = NO;
    } else {
        self.selectedIndexPath = indexPath;
        cell.showDetails = YES;
    }
    previous.showDetails = NO;
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const CGFloat height = 64.0;
    
    UTCSDirectoryPerson *person = nil;
    
    if (tableView == self.tableView) {
        person = self.dataSource.data[indexPath.section][indexPath.row];
        
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        person = ((UTCSDirectoryDataSource *)self.dataSource).flatDirectory[indexPath.row];
        
    }
    
    if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
        
        CGFloat selectedHeight = height;
        if (person.office) {
            selectedHeight += 16.0;
        }
        
        if (person.phoneNumber) {
            selectedHeight += 16.0;
        }
        
        return selectedHeight;
    }
    
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [UIView new];
    } else if (tableView == self.tableView) {
        UTCSDirectoryPerson *person = self.dataSource.data[section][0];
        NSString *letter = [[person.lastName substringToIndex:1]uppercaseString];
        return ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width - 8.0, 16.0)];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            label.text = [NSString stringWithFormat:@"    %@", letter];
            label.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
            label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
            label;
        });
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((UTCSDirectoryTableViewCell *)cell).showDetails = NO;
    if (self.selectedIndexPath && [indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
        ((UTCSDirectoryTableViewCell *)cell).showDetails = YES;
    }
}

#pragma mark UTCSDataSourceCacheDelegate Methods

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource
{
    return @{directoryCacheKey: self.dataSource.data,
             flatDirectoryCacheKey :((UTCSDirectoryDataSource *)self.dataSource).flatDirectory};
}

#pragma mark UISearchDisplayDelegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    self.tableView.alpha = 0.0;
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.frame = self.tableView.frame;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    self.tableView.alpha = 1.0;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString * scope = self.searchBar.scopeButtonTitles[self.searchBar.selectedScopeButtonIndex];
    [self.dataSource.searchController searchWithQuery:searchString scope:scope completion:^(NSArray *searchResults) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = self.searchBar.text;
    NSString *scope = self.searchBar.scopeButtonTitles[searchOption];
    [self.dataSource.searchController searchWithQuery:searchString scope:scope completion:^(NSArray *searchResults) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
    return NO;
}

@end
