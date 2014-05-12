//
//  UTCSEventsDataSourceParser.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsDataSourceParser.h"
#import "UTCSEvent.h"

@implementation UTCSEventsDataSourceParser

- (NSArray *)parseValues:(NSArray *)values
{
    NSAssert([values isKindOfClass:[NSArray class]], @"Events data parser expects instance of NSArray");
    NSMutableArray *events = [NSMutableArray new];
    
    for (NSDictionary *eventData in values) {
        UTCSEvent *event    = [UTCSEvent new];
        event.name          = [self stringForDataString:eventData[@"name"]];
        event.contactName   = [self stringForDataString:eventData[@"contactName"]];
        event.contactEmail  = [self stringForDataString:eventData[@"contactEmail"]];
        event.location      = [self stringForDataString:eventData[@"location"]];
        event.description   = [self stringForDataString:eventData[@"description"]];
        event.type          = [self stringForDataString:eventData[@"type"]];
        event.link          = [self stringForDataString:eventData[@"link"]];

        NSString *startDateString = [self stringForDataString:eventData[@"startDate"]];
        event.startDate     = [self.dateFormatter dateFromString:startDateString];

        NSString *endDateString = [self stringForDataString:eventData[@"endDate"]];
        event.endDate       = [self.dateFormatter dateFromString:endDateString];

        event.allDay        = [eventData[@"allDay"]boolValue];
        event.food          = [eventData[@"food"]boolValue];
        event.eventID       = [self stringForDataString:eventData[@"id"]];

        [events addObject:event];
    }
    
    return events;
}

- (NSString *)stringForDataString:(NSString *)dataString
{
    if ([dataString isEqual:[NSNull null]]) {
        return nil;
    }
    return dataString;
}


@end
