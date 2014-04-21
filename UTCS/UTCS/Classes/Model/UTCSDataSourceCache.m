//
//  UTCSAbstractCache.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDataSourceCache.h"


#pragma mark - Constants

NSString * const UTCSDataSourceCacheValuesName    = @"UTCSDataSourceCacheValuesName";
NSString * const UTCSDataSourceCacheMetaDataName  = @"UTCSDataSourceCacheMetaDataName";


#pragma mark - UTCSAbstractDataSourceCache Implementation

@implementation UTCSDataSourceCache

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
    if (!self.service || !key) {
        return nil;
    }
    
    NSString *primaryKey = [self primaryKeyForService:self.service forKey:key];
    
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:primaryKey];
    
    if (data) {
        NSDictionary *cache = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return cache;
    }
    
    return nil;
}

- (void)cacheObject:(id)object withKey:(NSString *)key
{
    if (!self.service || !key || !object) {
        return;
    }
    
    UTCSDataSourceCacheMetaData *metaData = [self metaDataForService:self.service];
    NSDictionary *cache = @{UTCSDataSourceCacheMetaDataName : metaData, UTCSDataSourceCacheValuesName : object};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cache];
    
    NSString *primaryKey = [self primaryKeyForService:self.service forKey:key];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:primaryKey];
}

#pragma mark Helper

- (UTCSDataSourceCacheMetaData *)metaDataForService:(NSString *)service
{
    UTCSDataSourceCacheMetaData *metaData = [UTCSDataSourceCacheMetaData new];
    metaData.service = service;
    metaData.timestamp = [NSDate date];
    return metaData;
}

- (NSString *)primaryKeyForService:(NSString *)service forKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@_%@", service, key];
}

@end
