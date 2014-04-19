//
//  UTCSCacheManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

#import "UTCSCacheMetaData.h"


// Key for the meta data object in the cache dictionary
extern NSString * const UTCSCacheMetaName;

// Key for the original cached object in the cache dictionary
extern NSString * const UTCSCacheValuesName;


/**
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
