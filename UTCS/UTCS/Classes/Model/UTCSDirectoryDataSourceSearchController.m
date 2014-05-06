//
//  UTCSDirectoryDataSourceSearchController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryDataSourceSearchController.h"
#import "UTCSDirectoryDataSource.h"
#import "UTCSDirectoryPerson.h"
#import "UTCSBouncyTableViewCell.h"


@implementation UTCSDirectoryDataSourceSearchController

- (void)searchWithQuery:(NSString *)query scope:(NSString *)scope completion:(UTCSDataSourceSearchCompletion)completion
{
    if (!query && !scope) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    if ([scope isEqualToString:@"All"]) {
        scope = nil;
    }
    
    NSPredicate *predicate = nil;
    if (query && scope) {
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND (firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@)",
                     scope, query, query];
    } else if (query) {
        predicate = [NSPredicate predicateWithFormat:@"firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@", query, query];
    } else if (scope) {
        predicate = [NSPredicate predicateWithFormat:@"type = %@", scope];
    }
    
    UTCSDirectoryDataSource *dataSource = (UTCSDirectoryDataSource *)self.dataSource;
    self.searchResults = [dataSource.flatDirectory filteredArrayUsingPredicate:predicate];
    if (completion) {
        completion(self.searchResults);
    }
}

#pragma mak UISearchDisplayDelegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [super searchDisplayController:controller willShowSearchResultsTableView:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.frame = CGRectMake(0.0, CGRectGetHeight(self.searchDisplayController.searchBar.bounds) + 44.0, CGRectGetWidth(self.searchDisplayController.searchResultsTableView.bounds), CGRectGetHeight(self.searchDisplayController.searchResultsTableView.bounds) - CGRectGetHeight(self.searchDisplayController.searchBar.bounds));
    
    tableView.contentOffset = CGPointZero;
    tableView.contentInset = UIEdgeInsetsZero;
    tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.1];
}

@end
