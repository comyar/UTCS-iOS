//
//  UTCSEventsDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;


/**
 */
typedef void (^UTCSEventsDataSourceCompletion) (NSDate *updated);


/**
 UTCSEventsDataSource
 */
@interface UTCSEventsDataSource : NSObject <UITableViewDataSource>

// -----
// @name Updating
// -----

/**
 */
- (void)updateEventsWithCompletion:(UTCSEventsDataSourceCompletion)completion;

// -----
// @name Using a UTCSEventsDataSource
// -----

/**
 */
- (void)filterEventsByType:(NSString *)type;

// -----
// @name Properties
// -----

/**
 */
@property (nonatomic, readonly) NSArray *filteredEvents;

@end
