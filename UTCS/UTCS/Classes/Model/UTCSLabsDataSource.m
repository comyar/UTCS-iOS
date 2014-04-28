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

@implementation UTCSLabsDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        _cache  = [[UTCSDataSourceCache alloc]initWithService:service];
        _parser = [UTCSLabsDataSourceParser new];
        _searchController = [UTCSLabsDataSourceSearchController new];
        _searchController.dataSource = self;
    }
    return self;
}

@end
