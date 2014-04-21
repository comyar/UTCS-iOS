//
//  UTCSAbstractCache.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

@import Foundation;

@interface UTCSAbstractDataSourceCache : NSObject

/**
 */
- (void)objectWithKey:(NSString *)key;

/**
 */
- (void)cacheObject:(id)object withKey:(NSString *)key;

@end
