//
//  UTCSAbstractCache.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAbstractDataSourceCache.h"


NSString * const UTCSDataSourceCacheValuesName    = @"UTCSDataSourceCacheValuesName";
NSString * const UTCSDataSourceCacheMetaDataName  = @"UTCSDataSourceCacheMetaDataName";

#pragma mark - UTCSAbstractDataSourceCache Implementation

@implementation UTCSAbstractDataSourceCache

#pragma mark Creating a UTCSAbstractDataSourceCache

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super init]) {
        _service = service;
    }
    return self;
}

#pragma mark Using a UTCSAbstractDataSourceCache

- (NSDictionary *)objectWithKey:(NSString *)key
{
    return nil;
}

- (void)cacheObject:(id)object withKey:(NSString *)key
{
    
}

@end
