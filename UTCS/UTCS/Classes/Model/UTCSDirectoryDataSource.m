//
//  UTCSDirectoryManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

#import "UTCSDirectoryDataSource.h"
#import "UTCSDirectoryPerson.h"
#import "UTCSDirectoryDataSourceParser.h"
#import "UTCSDataSourceCache.h"
#import "UTCSDirectoryDataSourceSearchController.h"
#import "UTCSBouncyTableViewCell.h"


#pragma mark - Constants
// Key used to cache directory
NSString * const UTCSDirectoryCacheKey      = @"UTCSDirectoryCacheKey";

// Key used to cache flat directory
NSString * const UTCSDirectoryFlatCacheKey  = @"UTCSDirectoryFlatCacheKey";


#pragma mark - UTCSDirectoryDataSource Class Extension

@interface UTCSDirectoryDataSource ()

@property (nonatomic) NSArray *flatDirectory;

@end


#pragma mark - UTCSDirectoryDataSource Implementation

@implementation UTCSDirectoryDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        _minimumTimeBetweenUpdates = 2592000.0;  // 30 days
        _cache = [[UTCSDataSourceCache alloc]initWithService:service];
        _parser = [UTCSDirectoryDataSourceParser new];
        _primaryCacheKey = UTCSDirectoryCacheKey;
        
        _searchController = [UTCSDirectoryDataSourceSearchController new];
        self.searchController.dataSource = self;
        
        NSDictionary *cache = [_cache objectWithKey:UTCSDirectoryCacheKey];
        _data           = cache[UTCSDataSourceCacheValuesName];
        
        cache = [_cache objectWithKey:UTCSDirectoryFlatCacheKey];
        _flatDirectory  = cache[UTCSDataSourceCacheValuesName];
    }
    return self;
}

- (void)buildFlatDirectory
{
    NSMutableArray *flatDirectory = [NSMutableArray new];
    for (NSArray *letter in self.data) {
        for (UTCSDirectoryPerson *person in letter) {
            [flatDirectory addObject:person];
        }
    }
    _flatDirectory = flatDirectory;
}

- (UTCSBouncyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSBouncyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSDirectoryTableViewCell"];
    if(!cell) {
        cell = [[UTCSBouncyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSDirectoryTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UTCSDirectoryPerson *person = nil;
    
    if (tableView == self.searchController.searchDisplayController.searchResultsTableView) {
        person = self.searchController.searchResults[indexPath.row];
    } else {
        person = self.data[indexPath.section][indexPath.row];
    }
    
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc]initWithString:person.fullName];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:cell.textLabel.font.pointSize] range:NSMakeRange(0, [person.firstName length])];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:cell.textLabel.font.pointSize] range:NSMakeRange([person.firstName length] + 1, [person.lastName length])];
    
    cell.indentationLevel = 1;
    cell.textLabel.attributedText = attributedName;
    cell.detailTextLabel.text = person.type;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchController.searchDisplayController.searchResultsTableView) {
        return [self.searchController.searchResults count];
    } else {
        return [self.data[section] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchController.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [self.data count];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchController.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        NSMutableArray *letters = [NSMutableArray new];
        for (NSArray *letter in self.data) {
            UTCSDirectoryPerson *person = letter[0];
            NSString *firstLetter = [[person.lastName substringToIndex:1]uppercaseString];
            [letters addObject:firstLetter];
        }
        return letters;
    }
}

@end
