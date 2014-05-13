//
//  UTCSAbstractDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

@class UTCSDataSource;
@class UTCSDataSourceCache;
@class UTCSDataSourceParser;
@class UTCSDataSourceSearchController;

#import "UTCSDataRequestServicer.h"


/**
 Completion handler block for the data source
 */
typedef void (^UTCSDataSourceCompletion) (BOOL success, BOOL cacheHit);


#pragma mark - UTCSDataSourceDelegate Protocol

/**
 The delegate of a UTCSDataSource must adopt the UTCSDataSourceDelegate protocol. Optional methods of the protocol
 allow the delegate to manage which objects a data source caches to disk.
 */
@protocol UTCSDataSourceDelegate <NSObject>

@optional

/**
 Asks the delegate for the set of objects that should be cached to disk.
 
 Each key in the dictionary will be used as the cache key for the object it's associated with.
 @param dataSource Data source requesting objects to cache
 @return Dictionary of objects to cache along with their associated keys, may be nil
 */
- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource;

@end


#pragma mark - UTCSDataSource Interface

/**
 UTCSDataSource is an abstract class used to perform asynchronous API requests for a 
 specific service. UTCSDataSource instances are associated with a single service (e.g. "news",
 "events", etc.) and perform generalized API requests for updating data belonging to services.
 
 Each instance of UTCSDataSource must also own an instance of UTCSDataSourceParser, used to parse
 downloaded data. An instance of UTCSDataSource may also own an instance of UTCSDataSourceCache, used
 for caching service-specific data to disk, and UTCSDataSourceSearchController, which provides a 
 abstract API for searching a data source's data.
 
 For each service, you should create a subclass of UTCSDataSource (e.g. UTCSNewsDataSource) and configure it
 with the appropriate parser, search controller, etc. as needed. UTCSDataSource must be initialized using the
 initWithService: selector.
 */
@interface UTCSDataSource : NSObject <UISearchDisplayDelegate>
{
    @protected  // Protected ivars
    
    id                              _data;                      // Downloaded data
    NSTimeInterval                  _minimumTimeBetweenUpdates; // Minimum time between updates
    
    UTCSDataSourceCache             *_cache;                    // Cache instance, may be nil
    UTCSDataSourceParser            *_parser;                   // Parser instance, may not be nil
    NSDate                          *_updated;                  // Date the data source's data was updated
    NSString                        *_primaryCacheKey;          // Primary key to use when calculating time between updates
    UTCSDataSourceSearchController  *_searchController;         // Search controller instance, may be nil
}

// -----
// @name Creating a UTCSDataSource
// -----

/**
 Designated initializer. Initializes a new instance of UTCSDataSource.
 @param service String identifying the service associated with the newly initialized data source object
 @return Newly initialized instance of UTCSDataSource
 */
- (instancetype)initWithService:(NSString *)service;

// -----
// @name Using a UTCSDataSource
// -----

/**
 Returns YES if the data source should update
 
 Updating results in the data source performing an asynchronous API request.
 By default, UTCSDataSource uses the minimumTimeBetweenUpdates property and cached data
 to determine the return value. Concrete subclasses of UTCSDataSource may override this
 method to customize the update conditions for a data source.
 
 @return YES if the data source should update
 */
- (BOOL)shouldUpdate;

/**
 Performs an asnchronous API request to update the data source's data and attempts to
 cache downloaded data to disk. Objects are cached to disk after the completion handler 
 block is executed.
 @param argument    Argument required by the data source's service, may be nil
 @param completion  Handler block to execute on completion, may be nil
 */
- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion;

// -----
// @name Properties
// -----

/**
 Name of the service associated with this data source.
 */
@property (nonatomic, readonly) NSString                            *service;

/**
 Parsed data. The type of the data object is specific to the service.
 */
@property (nonatomic, readonly) id                                  data;

/**
 Parser to parse downloaded data, may not be nil.
 */
@property (nonatomic, readonly) UTCSDataSourceParser                *parser;

/**
 Cache to use when writing objects to disk, may be nil.
 */
@property (nonatomic, readonly) UTCSDataSourceCache                 *cache;

/**
 Search controller to use to search data, may be nil.
 */
@property (nonatomic, readonly) UTCSDataSourceSearchController      *searchController;

/**
 Key to use when calculating the time since last update.
 
 This key is used to access the cached object associated with this key
 and that object's metadata is used to determine whether an update is required.
 */
@property (nonatomic, readonly) NSString                            *primaryCacheKey;

/**
 Date the data source's data was updated.
 */
@property (nonatomic, readonly) NSDate                              *updated;

/**
 Minimum time between updates, in seconds.
 Default is 3600. (one hour)
 */
@property (nonatomic, readonly) NSTimeInterval                      minimumTimeBetweenUpdates;

/**
 Delegate object that conforms to the UTCSDataSourceDelegate protocol. 
 This is usually a view controller.
 */
@property (weak, nonatomic) id<UTCSDataSourceDelegate>              delegate;

@end
