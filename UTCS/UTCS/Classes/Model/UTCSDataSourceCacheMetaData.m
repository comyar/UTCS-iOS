//
//  UTCSCacheMetaData.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDataSourceCacheMetaData.h"


#pragma mark - Constants

// Key to store the service
static NSString * const serviceKey      = @"service";

// Key to store the timestamp
static NSString * const timestampKey    = @"timestamp";


#pragma mark - UTCSCacheMetaData Implementation

@implementation UTCSDataSourceCacheMetaData

#pragma mark NSCoding Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _service    = [aDecoder decodeObjectForKey:serviceKey];
        _timestamp  = [aDecoder decodeObjectForKey:timestampKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_service forKey:serviceKey];
    [aCoder encodeObject:_timestamp forKey:timestampKey];
}

@end
