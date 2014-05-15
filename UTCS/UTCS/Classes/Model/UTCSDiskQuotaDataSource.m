//
//  UTCSDiskQuotaDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDiskQuotaDataSource.h"
#import "UTCSDiskQuotaDataSourceParser.h"


#pragma mark - UTCSDiskQuotaDataSource Implementation

@implementation UTCSDiskQuotaDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        _parser = [UTCSDiskQuotaDataSourceParser new];
    }
    return self;
}

@end
