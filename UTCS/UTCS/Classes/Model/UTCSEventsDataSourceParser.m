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

- (id)parseValues:(NSArray *)values
{
    NSLog(@"events parser");
    NSAssert([values isKindOfClass:[NSArray class]], @"Events data parser expects instance of NSArray");
    NSMutableArray *events = [NSMutableArray new];
    
    for (NSDictionary *eventData in values) {
        UTCSEvent *event    = [UTCSEvent new];
        event.name          = (eventData[@"name"]               == [NSNull null])? nil : eventData[@"name"];
        event.contactName   = (eventData[@"contactName"]        == [NSNull null])? nil : eventData[@"contactName"];
        event.contactEmail  = (eventData[@"contactEmail"]       == [NSNull null])? nil : eventData[@"contactEmail"];
        event.location      = (eventData[@"location"]           == [NSNull null])? nil : eventData[@"location"];
        event.description   = (eventData[@"description"]        == [NSNull null])? nil : eventData[@"description"];
        event.type          = (eventData[@"type"]               == [NSNull null])? nil : eventData[@"type"];
        event.link          = (eventData[@"link"]               == [NSNull null])? nil : eventData[@"link"];

        NSString *startDateString = (eventData[@"startDate"]    == [NSNull null])? nil : eventData[@"startDate"];
        event.startDate     = [self.dateFormatter dateFromString:startDateString];

        NSString *endDateString = (eventData[@"endDate"]        == [NSNull null])? nil : eventData[@"endDate"];
        event.endDate       = [self.dateFormatter dateFromString:endDateString];

        event.allDay        = [eventData[@"allDay"]boolValue];
        event.food          = [eventData[@"food"]boolValue];

        [events addObject:event];
    }
    
    return events;
}
@end
