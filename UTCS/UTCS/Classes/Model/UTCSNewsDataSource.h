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
 UTCSNewsArticleDataSource
 */
@interface UTCSNewsDataSource : UTCSDataSource <UITableViewDataSource>


@end
