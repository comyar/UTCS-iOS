//
//  UTCSAbstractDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UTCSDataSource.h"
#import "UTCSDataSourceParser.h"
#import "UTCSDataSourceCache.h"
#import "UTCSDataSourceCacheMetaData.h"


#pragma mark - UTCSAbstractDataSource Implementation

@implementation UTCSDataSource
@synthesize data                        = _data;
@synthesize parser                      = _parser;
@synthesize cache                       = _cache;
@synthesize primaryCacheKey             = _primaryCacheKey;
@synthesize searchController            = _searchController;
@synthesize minimumTimeBetweenUpdates   = _minimumTimeBetweenUpdates;

#pragma mark Creating a UTCSDataSource

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"UTCSDataSource must be initialized with a service"
                                 userInfo:nil];
}

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super init]) {
        _service = service;
        _minimumTimeBetweenUpdates = 3600.0;
    }
    return self;
}

#pragma mark Using a UTCSDataSource

- (BOOL)shouldUpdate
{
    NSDictionary *cache = [self.cache objectWithKey:self.primaryCacheKey];
    UTCSDataSourceCacheMetaData *metaData = cache[UTCSDataSourceCacheMetaDataName];
    
    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < self.minimumTimeBetweenUpdates) {
        return NO;
    }
    
    return YES;
}

- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion
{
    // Check cache's metadata to determine if minimum time since last update has passed
    NSDictionary *cache = [self.cache objectWithKey:self.primaryCacheKey];
    UTCSDataSourceCacheMetaData *metaData = cache[UTCSDataSourceCacheMetaDataName];
    
    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < self.minimumTimeBetweenUpdates) {
        
        _data = cache[UTCSDataSourceCacheValuesName];
        _updated = metaData.timestamp;
        
        if (completion) {
            completion(YES, YES);
        }
        return;
    }
    
    // Make an API request to update data
    [UTCSDataRequestServicer sendDataRequestForService:self.service argument:argument completion:^(NSDictionary *meta, id values, NSError *error) {
        if ([meta[@"service"]isEqualToString:self.service] &&   // Check for matching service type and success
            [meta[@"success"]boolValue]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
                _data       = [self.parser parseValues:values]; // Parse the downloaded data using the parser
                _updated    = [NSDate date]; // Set the updated time
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(YES, NO);
                    }
                    
                    // Cache objects to disk
                    if ([self.delegate conformsToProtocol:@protocol(UTCSDataSourceDelegate)] &&
                        [self.delegate respondsToSelector:@selector(objectsToCacheForDataSource:)]) {
                        NSDictionary *objects = [self.delegate objectsToCacheForDataSource:self];
                        
                        for (NSString *key in objects) {
                            [self.cache cacheObject:objects[key] withKey:key];
                        }
                    }
                });
            });
            
        } else {
            // Update failed with no cache hit
            if (completion) {
                completion(NO, NO);
            }
        }
    }];
}

@end
