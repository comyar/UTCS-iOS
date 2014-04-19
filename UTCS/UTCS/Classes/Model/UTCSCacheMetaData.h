//
//  UTCSCacheMetaData.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;


/**
 UTCSCacheMetaData stores various metadata regarding specific objects cached by the
 UTCSCacheManager. 
 */
@interface UTCSCacheMetaData : NSObject <NSCoding>

/**
 Service the data was cached for
 */
@property (nonatomic) NSString  *service;

/**
 Time when the data was cached
 */
@property (nonatomic) NSDate    *timestamp;

@end
