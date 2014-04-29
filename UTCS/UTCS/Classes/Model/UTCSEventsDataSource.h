//
//  UTCSEventsDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSDataSource.h"

extern NSString * const UTCSEventsFilterRemoveName;
extern NSString * const UTCSEventsFilterAddName;

extern NSString * const UTCSEventsDataSourceCacheKey;

/**
 UTCSEventsDataSource
 */
@interface UTCSEventsDataSource : UTCSDataSource <UITableViewDataSource>

- (void)prepareFilter;
- (NSDictionary *)filterEventsWithType:(NSString *)type;

@end
