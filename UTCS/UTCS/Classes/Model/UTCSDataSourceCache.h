//
//  UTCSAbstractCache.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//



#pragma mark - Imports

@import Foundation;
#import "UTCSDataSourceCacheMetaData.h"


#pragma mark - Forward Declarations

@class UTCSDataSourceCache;


#pragma mark - Constants

// Key for the original cached object in the cache dictionary
extern NSString * const UTCSDataSourceCacheValuesName;

// Key for the meta data object in the cache dictionary
extern NSString * const UTCSDataSourceCacheMetaDataName;


#pragma mark - UTCSDataSourceCache Interface

/**
 UTCSDataSourceCache is an abstract class that provides a simple-to-use API
 for a data source to cache objects.
 
 While UTCSDataSourceCache does support the caching of single objects, it is intended to
 be used to cache collections, such as NSArray or NSDictionary.
 */
@interface UTCSDataSourceCache : NSObject
NS_ASSUME_NONNULL_BEGIN
// -----
// @name Creating a UTCSDataSourceCache
// -----

#pragma mark Creating a UTCSDataSourceCache

/**
 Designated initializer. Initializes a new instance of UTCSDataSourceCache.
 @param service Name of the service whose data is being cached. May not be nil.
 @return        Newly initialized instance of UTCSDataSourceCache
 */
- (instancetype)initWithService:(NSString *)service;

// -----
// @name Using a UTCSDataSourceCache
// -----

#pragma mark Using a UTCSDataSourceCache

/**
 Retrieves an object associated with the given key from the cache.
 @param key Key used to cache the object.
 @return    Dictionary containing the object and its associated metadata. nil if no object found.
 */
- (NSDictionary * __nullable)objectWithKey:(NSString *)key;

/**
 Caches an object and associates it with the given key.
 @param object  Object to cache. May not be nil
 @param key     Key to associate with the object. May not be nil.
 */
- (void)cacheObject:(id)object withKey:(NSString *)key;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Name of the service whose data is being cached.
 */
@property (nonatomic, readonly) NSString *service;

@end

NS_ASSUME_NONNULL_END
