//
//  UTCSDirectoryManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDataSource.h"


#pragma mark - Constants

/**
 Key to use to cache letter-divided directory.
 */
extern NSString * const UTCSDirectoryCacheKey;

/**
 Key to use to cache flattened directory.
 */
extern NSString * const UTCSDirectoryFlatCacheKey;


#pragma mark - UTCSDirectoryDataSource Interface

/**
 UTCSDirectoryDataSource is a concrete class that handles downloading, parsing, and caching
 of directory data. UTCSDirectoryDataSource also acts at the table view data source for the
 UTCSDirectoryViewController.
 
 UTCSDirectoryDataSource should not be subclassed.
 */
@interface UTCSDirectoryDataSource : UTCSDataSource <UITableViewDataSource>

// -----
// @name Using a Directory Data Source
// -----

#pragma mark Using a Directory Data Source

/**
 Creates a flattened version of the directory from the data source's data.
 */
- (void)buildFlatDirectory;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Flattened version of the directory data. 
 
 UTCSDirectoryPerson objects in this 1-D array are ordered by last name.
 */
@property (nonatomic, readonly) NSArray *flatDirectory;

@end
