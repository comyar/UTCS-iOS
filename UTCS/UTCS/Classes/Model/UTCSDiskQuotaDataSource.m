//
//  UTCSDiskQuotaDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

// Models
#import "UTCSDataSourceCache.h"
#import "UTCSDiskQuotaDataSource.h"
#import "UTCSDiskQuotaDataSourceParser.h"


#pragma mark - Constants

// Key used to cache disk quota data
NSString * const UTCSDiskQuotaDataSourceCacheKey = @"UTCSDiskQuotaDataSourceCacheKey";


#pragma mark - UTCSDiskQuotaDataSource Implementation

@implementation UTCSDiskQuotaDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        _minimumTimeBetweenUpdates = 10800.0;  // 3 hours 
        _parser = [UTCSDiskQuotaDataSourceParser new];
        _cache = [[UTCSDataSourceCache alloc]initWithService:service];
        
        // Restore cached disk quota information
        NSDictionary *cache = [_cache objectWithKey:UTCSDiskQuotaDataSourceCacheKey];
        _data = cache[UTCSDataSourceCacheValuesName];
    }
    return self;
}

@end
