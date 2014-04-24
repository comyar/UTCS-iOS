//
//  UTCSDataSourceSearchController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDataSourceSearchController.h"
#import "UTCSDataSource.h"

@implementation UTCSDataSourceSearchController

- (void)searchWithQuery:(NSString *)query scope:(NSString *)scope completion:(UTCSDataSourceSearchCompletion)completion
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

- (void)setSearchDisplayController:(UISearchDisplayController *)searchDisplayController
{
    _searchDisplayController = searchDisplayController;
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsTableView.delegate = self;
}

#pragma mark UISearchDisplayDelegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    for (UIView *subview in self.searchDisplayController.searchContentsController.view.subviews) {
        if ([subview isKindOfClass:[UITableView class]]) {
            subview.alpha = 0.0;
            tableView.frame = subview.frame;
        }
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    for (UIView *subview in self.searchDisplayController.searchContentsController.view.subviews) {
        if ([subview isKindOfClass:[UITableView class]]) {
            subview.alpha = 1.0;
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString * scope = self.self.searchDisplayController.searchBar.scopeButtonTitles[self.searchDisplayController.searchBar.selectedScopeButtonIndex];
    [self.dataSource.searchController searchWithQuery:searchString scope:scope completion:^(NSArray *searchResults) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = self.searchDisplayController.searchBar.text;
    NSString *scope = self.self.searchDisplayController.searchBar.scopeButtonTitles[searchOption];
    [self.dataSource.searchController searchWithQuery:searchString scope:scope completion:^(NSArray *searchResults) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
    return NO;
}

@end
