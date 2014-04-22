//
//  UTCSDiskQuotaDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDiskQuotaDataSource.h"


@implementation UTCSDiskQuotaDataSource


- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        self.minimumTimeBetweenUpdates = 10800.0;  // 3 hours
    }
    return self;
}

@end
