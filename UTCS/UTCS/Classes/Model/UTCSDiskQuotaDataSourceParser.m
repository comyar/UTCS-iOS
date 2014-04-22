//
//  UTCSDiskQuotaDataSourceParser.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDiskQuotaDataSourceParser.h"

@implementation UTCSDiskQuotaDataSourceParser

- (NSDictionary *)parseValues:(NSDictionary *)values
{
    return @{@"name" : values[@"name"],
             @"user" : values[@"user"],
             @"limit" : (values[@"limit"] == [NSNull null])? nil : values[@"limit"],
             @"usage" : (values[@"usage"] == [NSNull null])? nil : values[@"usage"]
             };
}


@end
