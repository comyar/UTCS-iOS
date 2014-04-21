//
//  UTCSAbstractCache.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

// Key for the meta data object in the cache dictionary
extern NSString * const UTCSDataSourceCacheMetaDataName;

// Key for the original cached object in the cache dictionary
extern NSString * const UTCSDataSourceCacheValuesName;


/**
 UTCSAbstractDataSourceCache is an abstract class that provides a simple-to-use API 
 for a data source to cache objects.
 
 While UTCSAbstractDataSourceCache does support the caching of single objects, it is intended to
 be used to cache collections, such as NSArray or NSDictionary.
 */
@interface UTCSAbstractDataSourceCache : NSObject

// -----
// @name Creating a UTCSAbstractDataSourceCache
// -----

/**
 */
- (instancetype)initWithService:(NSString *)service;

// -----
// @name Using a UTCSAbstractDataSourceCache
// -----

/**
 */
- (NSDictionary *)objectWithKey:(NSString *)key;

/**
 */
- (void)cacheObject:(id)object withKey:(NSString *)key;

// -----
// @name Properties
// -----

@property (nonatomic, readonly) NSString *service;

@end
