//
//  UTCSDirectoryManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDirectoryPerson.h"
#import "UTCSDataSourceCache.h"
#import "UTCSBouncyTableViewCell.h"
#import "UTCSDirectoryDataSource.h"
#import "UTCSDirectoryDataSourceParser.h"
#import "UTCSDirectoryDataSourceSearchController.h"


#pragma mark - Constants

// Name of the directory service.
NSString * const UTCSDirectoryServiceName                       = @"directory";

// Directory table view cell identifier.
static NSString * const UTCSDirectoryTableViewCellIdentifier    = @"UTCSDirectoryTableViewCell";

// Font to use for a person's first name
static NSString * const firstNameFont                           = @"HelveticaNeue-Light";

// Font to use for a person's last name
static NSString * const lastNameFont                            = @"HelveticaNeue-Bold";

// Key used to cache directory
NSString * const UTCSDirectoryCacheKey                          = @"UTCSDirectoryCacheKey";

// Key used to cache flat directory
NSString * const UTCSDirectoryFlatCacheKey                      = @"UTCSDirectoryFlatCacheKey";

// Minimum time between updates
static const NSTimeInterval minimumTimeBetweenUpdates           = 2592000.0;  // 30 days


#pragma mark - UTCSDirectoryDataSource Class Extension

@interface UTCSDirectoryDataSource ()

// Flattened version of the directory data.
@property (nonatomic) NSArray *flatDirectory;

@end


#pragma mark - UTCSDirectoryDataSource Implementation

@implementation UTCSDirectoryDataSource

#pragma mark Creating a Directory Data Source

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        _minimumTimeBetweenUpdates = minimumTimeBetweenUpdates;
        
        _parser = [UTCSDirectoryDataSourceParser new];
        
        _primaryCacheKey = UTCSDirectoryCacheKey;
        _cache = [[UTCSDataSourceCache alloc]initWithService:service];
        
        _searchController = [UTCSDirectoryDataSourceSearchController new];
        _searchController.dataSource = self;
        
        // Check for cached data
        NSDictionary *dataCache = [_cache objectWithKey:UTCSDirectoryCacheKey];
        NSDictionary *flatCache = [_cache objectWithKey:UTCSDirectoryFlatCacheKey];
        UTCSDataSourceCacheMetaData *dataMeta = dataCache[UTCSDataSourceCacheMetaDataName];
        _data           = dataCache[UTCSDataSourceCacheValuesName];
        _flatDirectory  = flatCache[UTCSDataSourceCacheValuesName];
        _updated        = dataMeta.timestamp;
    }
    return self;
}

#pragma mark Using a Directory Data Source

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

#pragma mark UITableViewDataSource Methods

- (UTCSBouncyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSBouncyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UTCSDirectoryTableViewCellIdentifier];
    if(!cell) {
        cell = [[UTCSBouncyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UTCSDirectoryTableViewCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    UTCSDirectoryPerson *person = nil;
    
    if (tableView == self.searchController.searchDisplayController.searchResultsTableView) {
        person = self.searchController.searchResults[indexPath.row];
    } else {
        person = self.data[indexPath.section][indexPath.row];
    }
    
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc]initWithString:person.fullName];
    
    [attributedName addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:firstNameFont size:cell.textLabel.font.pointSize]
                           range:NSMakeRange(0, [person.firstName length])];
    
    [attributedName addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:lastNameFont size:cell.textLabel.font.pointSize]
                           range:NSMakeRange([person.firstName length] + 1, [person.lastName length])];
    
    cell.indentationLevel           = 1;
    cell.textLabel.attributedText   = attributedName;
    cell.detailTextLabel.text       = person.type;

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
