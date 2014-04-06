//
//  UTCSEvent.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEvent.h"

NSString * const UTCSParseEventName             = @"name";
NSString * const UTCSParseEventContactName      = @"contactName";
NSString * const UTCSParseEventContactEmail     = @"contactEmail";
NSString * const UTCSParseEventLocation         = @"location";
NSString * const UTCSParseEventHTMLDescription  = @"description";
NSString * const UTCSParseEventStartDate        = @"dateStart";
NSString * const UTCSParseEventEndDate          = @"dateEnd";

@implementation UTCSEvent

+ (UTCSEvent *)eventWithParseObject:(PFObject *)object
{
    return [[UTCSEvent alloc]initWithParseObject:object];
}

- (instancetype)initWithParseObject:(PFObject *)object
{
    if(self = [super init]) {
        _name               = object[UTCSParseEventName];
        _contactName        = object[UTCSParseEventContactName];
        _contactEmail       = object[UTCSParseEventContactEmail];
        _location           = object[UTCSParseEventLocation];
        _startDate          = object[UTCSParseEventStartDate];
        _endDate            = object[UTCSParseEventEndDate];
        _HTMLDescription    = object[UTCSParseEventHTMLDescription];
        _allDay             = object[@"allday"];
    }
    return self;
}

@end
