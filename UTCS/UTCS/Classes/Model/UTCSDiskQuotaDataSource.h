//
//  UTCSDiskQuotaDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSDataSource.h"

extern NSString * const UTCSDiskQuotaDataSourceCacheKey;

/**
 UTCSDiskQuotaDataSource is a concrete class that handles downloading, parsing, and caching
 of disk quota information.
 
 UTCSDiskQuotaDataSource should not be subclassed.
 */
@interface UTCSDiskQuotaDataSource : UTCSDataSource

@end
