//
//  UTCSCacheMetaData.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// Models
#import "UTCSCacheMetaData.h"


#pragma mark - Constants

// NSCoding keys
static NSString * const serviceKey      = @"service";
static NSString * const timestampKey    = @"timestamp";


#pragma mark - UTCSCacheMetaData Implementation

@implementation UTCSCacheMetaData

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
