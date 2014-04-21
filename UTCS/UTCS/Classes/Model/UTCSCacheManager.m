//
//  UTCSCacheManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports
#import "UTCSCacheManager.h"


#pragma mark - Constants
NSString * const UTCSDataSourceCacheValuesName    = @"UTCSDataSourceCacheValuesName";
NSString * const UTCSDataSourceCacheMetaDataName  = @"UTCSDataSourceCacheMetaDataName";



#pragma mark - UTCSCacheManager Implementation

@implementation UTCSCacheManager

#pragma mark Using UTCSCacheManager

+ (NSDictionary *)cacheForService:(NSString *)service withKey:(NSString *)key
{
    if (!service || !key) {
        return nil;
    }
    
    NSString *primaryKey = [UTCSCacheManager primaryKeyForService:service forKey:key];
    
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:primaryKey];
    if (data) {
        NSDictionary *cache = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return cache;
    }
    return nil;
}

+ (void)cacheObject:(id)object forService:(NSString *)service withKey:(NSString *)key
{
    if (!service || !key || !object) {
        return;
    }
    
    UTCSDataSourceCacheMetaData *metaData = [UTCSCacheManager metaDataForService:service];
    NSDictionary *cache = @{UTCSDataSourceCacheMetaDataName : metaData, UTCSDataSourceCacheValuesName : object};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cache];
    
    NSString *primaryKey = [UTCSCacheManager primaryKeyForService:service forKey:key];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:primaryKey];
    
}

#pragma mark Private

+ (UTCSDataSourceCacheMetaData *)metaDataForService:(NSString *)service
{
    UTCSDataSourceCacheMetaData *metaData = [UTCSDataSourceCacheMetaData new];
    metaData.service = service;
    metaData.timestamp = [NSDate date];
    return metaData;
}

+ (NSString *)primaryKeyForService:(NSString *)service forKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@_%@", service, key];
}

@end
