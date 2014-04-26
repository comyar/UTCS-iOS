//
//  UTCSNewsStoryDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSDataSource.h"

/**
 Key to use to cache news articles
 */
extern NSString * const UTCSNewsDataSourceCacheKey;

/**
 UTCSNewsArticleDataSource is a concrete class that handles downloading, parsing, and caching
 of news articles. UTCSNewsArticleDataSource also acts at the table view data source for the 
 UTCSNewsViewController.
 
 UTCSNewsArticleDataSource should not be subclassed.
 */
@interface UTCSNewsDataSource : UTCSDataSource <UITableViewDataSource>

@end
