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

@implementation UTCSLabsDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        self.cache  = [[UTCSDataSourceCache alloc]initWithService:service];
        self.parser = [UTCSLabsDataSourceParser new];
    }
    return self;
}

@end
