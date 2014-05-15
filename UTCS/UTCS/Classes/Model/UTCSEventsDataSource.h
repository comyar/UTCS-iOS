//
//  UTCSEventsDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDataSource.h"


#pragma mark - Constants

/**
 Key associated with index paths added by a filter.
 */
extern NSString * const UTCSEventsFilterAddName;

/**
 Key associated with index paths removed by a filter.
 */
extern NSString * const UTCSEventsFilterRemoveName;

/**
 Key used to cache events.
 */
extern NSString * const UTCSEventsDataSourceCacheKey;


#pragma mark - UTCSEventsDataSource Interface

/**
 UTCSEventsDataSource is a concrete class that handles downloading, parsing, and caching
 of UTCS events. UTCSEventsDataSource also acts at the table view data source for the
 UTCSEventsViewController.
 
 UTCSEventsDataSource should not be subclassed.
 */
@interface UTCSEventsDataSource : UTCSDataSource <UITableViewDataSource>

// -----
// @name Using an Events Data Source
// -----

#pragma mark Using an Events Data Source

/**
 Prepares the data source for filtering.
 
 Should be called anytime changes are made to the data source's data.
 */
- (void)prepareFilter;

/**
 Filters events by the given type.
 @param type    Type of event to filter by.
 @return Dictionary of index paths to add/remove from the events table view.
 */
- (NSDictionary *)filterEventsWithType:(NSString *)type;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Events matching the type of currentFilterType
 */
@property (nonatomic, readonly) NSMutableArray    *filteredEvents;

@end
