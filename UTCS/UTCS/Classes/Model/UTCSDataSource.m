//
//  UTCSAbstractDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDataSource.h"
#import "UTCSDataSourceParser.h"
#import "UTCSDataSourceCache.h"
#import "UTCSDataSourceCacheMetaData.h"

#pragma mark - UTCSAbstractDataSource Implementation

@implementation UTCSDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super init]) {
        _service = service;
        _minimumTimeBetweenUpdates = 3600.0;
    }
    return self;
}

- (BOOL)shouldUpdate
{
    NSString *reason = [NSString stringWithFormat:@"Cannont perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion
{
    if (!self.service) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    // Check cache
    NSDictionary *cache = [self.dataSourceCache objectWithKey:self.service];
    UTCSDataSourceCacheMetaData *metaData = cache[UTCSDataSourceCacheMetaDataName];
    
    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < self.minimumTimeBetweenUpdates) {
        
        _data = cache[UTCSDataSourceCacheValuesName];
        _updated = metaData.timestamp;
        
        if (completion) {
            completion(YES);
        }
        return;
    }
    
    // Make request
    [UTCSDataRequestServicer sendDataRequestWithType:0 argument:argument success:^(NSDictionary *meta, NSDictionary *values) {
        if ([meta[@"service"]isEqualToString:self.service] && meta[@"success"]) {
            
            _data       = [self.dataSourceParser parseValues:values];
            _updated    = [NSDate date];
            
            if (completion) {
                completion(YES);
            }
            
            if ([self.delegate conformsToProtocol:@protocol(UTCSDataSourceDelegate)] &&
                [self.delegate respondsToSelector:@selector(objectsToCacheForDataSource:)]) {
                NSDictionary *objects = [self.delegate objectsToCacheForDataSource:self];
                
                for (NSString *key in objects) {
                    [self.dataSourceCache cacheObject:objects[key] withKey:key];
                }
            }
            
        } else {
            if (completion) {
                completion(NO);
            }
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(NO);
        }
    }];
}

@end
