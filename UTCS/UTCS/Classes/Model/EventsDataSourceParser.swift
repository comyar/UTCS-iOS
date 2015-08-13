import SwiftyJSON

class EventsDataSourceParser: DataSourceParser {
    override func parseValues(values: JSON) {
        var events = [UTCSEvent]()
        for eventData in values.array! {
            let event = UTCSEvent()
            event.name = eventData["name"].string
        }
    }
}
/*
- (NSArray *)parseValues:(NSArray *)values
{
    NSMutableArray *events = [NSMutableArray new];
    
    for (NSDictionary *eventData in values) {
        UTCSEvent *event            = [UTCSEvent new];
        event.name                  = [self stringForDataString:eventData[@"name"]];
        event.contactName           = [self stringForDataString:eventData[@"contactName"]];
        event.contactEmail          = [self stringForDataString:eventData[@"contactEmail"]];
        event.location              = [self stringForDataString:eventData[@"location"]];
        event.eventDescription      = [self stringForDataString:eventData[@"description"]];
        event.type                  = [self stringForDataString:eventData[@"type"]];
        event.link                  = [self stringForDataString:eventData[@"link"]];

        NSString *startDateString   = [self stringForDataString:eventData[@"startDate"]];
        event.startDate             = [self.dateFormatter dateFromString:startDateString];

        NSString *endDateString     = [self stringForDataString:eventData[@"endDate"]];
        event.endDate               = [self.dateFormatter dateFromString:endDateString];

        event.allDay                = [eventData[@"allDay"]boolValue];
        event.food                  = [eventData[@"food"]boolValue];
        event.eventID               = [self stringForDataString:eventData[@"id"]];

        [events addObject:event];
    }
    
    return events;
}

#pragma mark Helper

- (NSString *)stringForDataString:(NSString *)dataString
{
    if ([dataString isEqual:[NSNull null]]) {
        return nil;
    }
    return dataString;
}

@end
*/