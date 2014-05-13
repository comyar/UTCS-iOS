//
//  UTCSDataSourceSearchController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDataSourceSearchController.h"
#import "UTCSDataSource.h"


#pragma mark - UTCSDataSourceSearchController Implementation

@implementation UTCSDataSourceSearchController

#pragma mark Using a UTCSDataSourceSearchController

- (void)searchWithQuery:(NSString *)query scope:(NSString *)scope completion:(UTCSDataSourceSearchCompletion)completion
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

#pragma mark Setters

- (void)setSearchDisplayController:(UISearchDisplayController *)searchDisplayController
{
    _searchDisplayController = searchDisplayController;
    _searchDisplayController.delegate = self;
}

#pragma mark UISearchDisplayDelegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    // Hides any table views in the searchContentsController and adjusts the frame of the searchResultsTableView to match
    // Ideally, there would only be one table view in the search contents controller.
    for (UIView *subview in self.searchDisplayController.searchContentsController.view.subviews) {
        if ([subview isKindOfClass:[UITableView class]]) {
            tableView.frame = subview.frame;
            subview.hidden = YES;
        }
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    // Unhides any table views in the searchContentsController
    // Ideally, there would only be one table view in the search contents controller.
    for (UIView *subview in self.searchDisplayController.searchContentsController.view.subviews) {
        if ([subview isKindOfClass:[UITableView class]]) {
            subview.hidden = NO;
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString * scope = self.searchDisplayController.searchBar.scopeButtonTitles[self.searchDisplayController.searchBar.selectedScopeButtonIndex];
    [self searchWithQuery:searchString scope:scope completion:^(NSArray *searchResults) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *query = self.searchDisplayController.searchBar.text;
    NSString *scope = self.searchDisplayController.searchBar.scopeButtonTitles[searchOption];
    [self searchWithQuery:query scope:scope completion:^(NSArray *searchResults) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
    return NO;
}

@end
