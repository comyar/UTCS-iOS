//
//  UTCSLabMachine.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabMachine.h"


@implementation UTCSLabMachine

+ (UTCSLabMachine *)labMachineWithParseObject:(PFObject *)object
{
    return [[UTCSLabMachine alloc]initWithParseObject:object];
}

- (instancetype)initWithParseObject:(PFObject *)object
{
    if(self = [super init]) {
        _hostname = object[@"name"];
        _occupied = [object[@"occupied"]boolValue];
        _labNumber = [object[@"labNumber"]integerValue];
    }
    return self;
}

@end
