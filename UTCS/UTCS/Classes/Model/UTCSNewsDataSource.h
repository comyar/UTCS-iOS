//
//  UTCSNewsStoryDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDataSource.h"


#pragma mark - Constants

/**
 Name of the news service.
 */
extern NSString * const UTCSNewsServiceName;

/**
 Key to use to cache news articles.
 */
extern NSString * const UTCSNewsDataSourceCacheKey;


#pragma mark - UTCSNewsDataSource Interface

/**
 UTCSNewsDataSource is a concrete class that handles downloading, parsing, and caching
 of news articles. UTCSNewsDataSource also acts at the table view data source for the
 UTCSNewsViewController.
 
 UTCSNewsDataSource should not be subclassed.
 */
@interface UTCSNewsDataSource : UTCSDataSource <UITableViewDataSource>

@end
