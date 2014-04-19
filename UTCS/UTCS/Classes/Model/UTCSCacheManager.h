//
//  UTCSCacheManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

#import "UTCSCacheMetaData.h"

//
extern NSString * const UTCSCacheMetaName;

//
extern NSString * const UTCSCacheValuesName;


/**
 */
@interface UTCSCacheManager : NSObject


// -----
// @name Using UTCSCacheManager
// -----

/**
 */
+ (NSDictionary *)cacheForService:(NSString *)service withKey:(NSString *)key;

/**
 */
+ (void)cacheObject:(id)object forService:(NSString *)service withKey:(NSString *)key;

@end
