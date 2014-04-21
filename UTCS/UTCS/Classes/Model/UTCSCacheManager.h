//
//  UTCSCacheManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

#import "UTCSDataSourceCacheMetaData.h"


// Key for the meta data object in the cache dictionary
extern NSString * const UTCSDataSourceCacheMetaDataName;

// Key for the original cached object in the cache dictionary
extern NSString * const UTCSDataSourceCacheValuesName;


/**
 The UTCSCacheManager provides a simple-to-use API for caching objects 
 to disk for services within the app (News, Events, etc). 
 
 While UTCSCacheManager does support the caching of single objects, it is intended to 
 be used to cache collections, such as NSArray or NSDictionary.
 */
@interface UTCSCacheManager : NSObject

// -----
// @name Using UTCSCacheManager
// -----

/**
 Returns the cache for a given service, key pair or nil if there is none.
 
 The returned cache is a dictionary containing the original cached object
 as well as an instance of UTCSCacheMetaData. The instance of UTCSCacheMetaData 
 indicates the service the cache is associated with as well as a timestamp for
 when the cache was created.
 
 @param service     Name of the service that cached the object
 @param key         Unique key that identifies the cached object
 @return            Cache dictionary, or nil if no available cache
 */
+ (NSDictionary *)cacheForService:(NSString *)service withKey:(NSString *)key;

/**
 Caches an object to disk
 @param service     Name of the service caching the object
 @param key         Unique key to identify the object with
 */
+ (void)cacheObject:(id)object forService:(NSString *)service withKey:(NSString *)key;

@end
