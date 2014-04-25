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

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

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
    NSDictionary *cache = [self.cache objectWithKey:self.service];
    UTCSDataSourceCacheMetaData *metaData = cache[UTCSDataSourceCacheMetaDataName];
    
    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < self.minimumTimeBetweenUpdates) {
        return NO;
    }
    
    return YES;
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
    NSDictionary *cache = [self.cache objectWithKey:self.service];
    UTCSDataSourceCacheMetaData *metaData = cache[UTCSDataSourceCacheMetaDataName];
    
    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < self.minimumTimeBetweenUpdates) {
        
        NSLog(@"Cache hit");
        
        _data = cache[UTCSDataSourceCacheValuesName];
        _updated = metaData.timestamp;
        
        if (completion) {
            completion(YES);
        }
        return;
    }
    
    NSLog(@"Cache miss");
    
    // Make request
    [UTCSDataRequestServicer sendDataRequestForService:self.service argument:argument completion:^(NSDictionary *meta, id values, NSError *error) {
        if ([meta[@"service"]isEqualToString:self.service] && [meta[@"success"]boolValue]) {
            
            _data       = [self.parser parseValues:values];
            _updated    = [NSDate date];
            
            if (completion) {
                completion(YES);
            }
            
            if ([self.delegate conformsToProtocol:@protocol(UTCSDataSourceDelegate)] &&
                [self.delegate respondsToSelector:@selector(objectsToCacheForDataSource:)]) {
                NSDictionary *objects = [self.delegate objectsToCacheForDataSource:self];
                
                for (NSString *key in objects) {
                    [self.cache cacheObject:objects[key] withKey:key];
                }
            }
            
        } else {
            if (completion) {
                completion(NO);
            }
        }
    }];
}

@end
