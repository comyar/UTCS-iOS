//
//  UTCSDirectoryDataSourceSearchController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryDataSourceSearchController.h"
#import "UTCSDirectoryTableViewCell.h"
#import "UTCSDirectoryDataSource.h"
#import "UTCSDirectoryPerson.h"



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

#pragma mark UITableViewDataSource Methods

- (UTCSDirectoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSDirectoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSDirectorySearchTableViewCell"];
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSDirectorySearchTableViewCell"];
        cell = [[UTCSDirectoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSDirectoryTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    UTCSDirectoryPerson *person = self.searchResults[indexPath.row];
    
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc]initWithString:person.fullName];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:cell.textLabel.font.pointSize] range:NSMakeRange(0, [person.firstName length])];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:cell.textLabel.font.pointSize] range:NSMakeRange([person.firstName length] + 1, [person.lastName length])];
    
    cell.textLabel.attributedText = attributedName;
    cell.detailTextLabel.text = person.type;
    cell.phoneNumberTextView.text = (person.phoneNumber)? person.phoneNumber : @"";
    cell.officeLabel.text = (person.office)? person.office : @"";
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

#pragma mark UITableViewDelegate Methods

#pragma mak UISearchDisplayDelegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [super searchDisplayController:controller willShowSearchResultsTableView:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.frame = CGRectMake(0.0, CGRectGetHeight(self.searchDisplayController.searchBar.bounds) + 44.0, CGRectGetWidth(self.searchDisplayController.searchResultsTableView.bounds), CGRectGetHeight(self.searchDisplayController.searchResultsTableView.bounds) - CGRectGetHeight(self.searchDisplayController.searchBar.bounds));
    
    tableView.contentOffset = CGPointZero;
    tableView.contentInset = UIEdgeInsetsZero;
    tableView.rowHeight = 96.0;
}

@end
