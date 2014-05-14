//
//  UTCSCacheMetaData.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

@import Foundation;


#pragma mark - UTCSDataSourceCacheMetaData Interface

/**
 UTCSCacheMetaData stores metadata regarding a specific object cached by a
 subclass of UTCSDataSourceCache. Instances of UTCSCacheMetaData should only
 be created by an instance of UTCSDataSourceCache.
 */
@interface UTCSDataSourceCacheMetaData : NSObject <NSCoding>

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Service the data was cached for.
 */
@property (nonatomic) NSString  *service;

/**
 Time when the data was cached
 */
@property (nonatomic) NSDate    *timestamp;

@end
