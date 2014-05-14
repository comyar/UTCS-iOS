//
//  UTCSLabsDataSourceSearchController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsDataSourceSearchController.h"
#import "UTCSLabsDataSource.h"
#import "UTCSLabMachine.h"


@implementation UTCSLabsDataSourceSearchController
@synthesize searchResults = _searchResults;

- (void)searchWithQuery:(NSString *)query scope:(NSString *)scope completion:(UTCSDataSourceSearchCompletion)completion
{
    scope = [scope lowercaseString];
    
    NSString *labName = [[scope componentsSeparatedByString:@" "]firstObject];
    if (!labName) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    NSDictionary *machineValues = self.dataSource.data[labName];
    
    NSArray *machines = [machineValues allValues];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lab = %@ AND name BEGINSWITH %@", labName, query];
    _searchResults = [machines filteredArrayUsingPredicate:predicate];
    
    if (completion) {
        completion(self.searchResults);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSLabsTableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSLabsTableViewCell"];
    }
    
    UTCSLabMachine *machine = self.searchResults[indexPath.row];
    cell.textLabel.text = machine.name;
    cell.detailTextLabel.text = machine.lab;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

@end
