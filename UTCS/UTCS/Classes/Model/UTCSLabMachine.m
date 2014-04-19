//
//  UTCSLabMachine.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// Models
#import "UTCSLabMachine.h"


#pragma mark - Constants

// Encoding keys
static NSString *labKey         = @"lab";
static NSString *nameKey        = @"name";
static NSString *uptimeKey      = @"uptime";
static NSString *statusKey      = @"status";
static NSString *occupiedKey    = @"occupied";
static NSString *loadKey        = @"load";


#pragma mark - UTCSLabMachine Implementation

@implementation UTCSLabMachine

#pragma mark NSCoding Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        self.lab        = [aDecoder decodeObjectForKey:labKey];
        self.name       = [aDecoder decodeObjectForKey:nameKey];
        self.uptime     = [aDecoder decodeObjectForKey:uptimeKey];
        self.status     = [aDecoder decodeObjectForKey:statusKey];
        self.occupied   = [aDecoder decodeBoolForKey:occupiedKey];
        self.load       = [aDecoder decodeFloatForKey:loadKey];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.lab       forKey:labKey];
    [aCoder encodeObject:self.name      forKey:nameKey];
    [aCoder encodeObject:self.uptime    forKey:uptimeKey];
    [aCoder encodeObject:self.status    forKey:statusKey];
    [aCoder encodeBool:self.occupied    forKey:occupiedKey];
    [aCoder encodeFloat:self.load       forKey:loadKey];
}

@end
