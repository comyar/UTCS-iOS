//
//  UTCSLabsManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsDataSource.h"
#import "UTCSLabMachine.h"
#import "UTCSLabsDataSourceParser.h"
#import "UTCSDataSourceCache.h"
#import "UTCSLabsDataSourceSearchController.h"

NSString * const UTCSLabsDataSourceCacheKey = @"UTCSLabsDataSourceCacheKey";

@implementation UTCSLabsDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        _cache  = [[UTCSDataSourceCache alloc]initWithService:service];
        _parser = [UTCSLabsDataSourceParser new];
        _searchController = [UTCSLabsDataSourceSearchController new];
        _searchController.dataSource = self;
        _minimumTimeBetweenUpdates = 750; // 15 minutes
        
        NSDictionary *cache = [self.cache objectWithKey:UTCSLabsDataSourceCacheKey];
        if (cache) {
            UTCSDataSourceCacheMetaData *meta = cache[UTCSDataSourceCacheMetaDataName];
            _data = cache[UTCSDataSourceCacheValuesName];
            _updated = meta.timestamp;
        }
    }
    return self;
}

@end
