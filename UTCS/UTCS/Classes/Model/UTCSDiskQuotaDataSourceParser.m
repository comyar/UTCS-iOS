//
//  UTCSDiskQuotaDataSourceParser.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDiskQuotaDataSourceParser.h"


#pragma mark - UTCSDiskQuotaDataSourceParser Implementation

@implementation UTCSDiskQuotaDataSourceParser

- (NSDictionary *)parseValues:(NSDictionary *)values
{
    NSMutableDictionary *parsed = [NSMutableDictionary new];
    for (NSString *key in values) {
        if (values[key] != [NSNull null]) {
            parsed[key] = values[key];
        }
    }
    return parsed;
}

@end
