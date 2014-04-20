//
//  UTCSEventsDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// Models
#import "UTCSEvent.h"
#import "UTCSCacheManager.h"
#import "UTCSEventsDataSource.h"
#import "UTCSDataRequestServicer.h"

// Views
#import "UTCSEventTableViewCell.h"

// Categoris
#import "UIColor+UTCSColors.h"


#pragma mark - Constants

// Key used to cache news articles
static NSString * const eventsCacheKey      = @"events";

// Minimum time between updates, in seconds
static CGFloat minimumTimeBetweenUpdates    = 10800.0;  // 3 hours


#pragma mark - UTCSEventsDataSoure Class Extension

@interface UTCSEventsDataSource ()

// Array of all the events
@property (nonatomic) NSArray           *events;

// Current type to filter events by
@property (nonatomic) NSString          *currentFilter;

// Date formatter for a 3-letter month name
@property (nonatomic) NSDateFormatter   *monthDateFormatter;

// Date formatter for a zero-padded day of the month
@property (nonatomic) NSDateFormatter   *dayDateFormatter;

// Mapping between event type to color
@property (nonatomic) NSDictionary      *typeColorMapping;

// Date formatter
@property (nonatomic) NSDateFormatter *dateFormatter;

@end


#pragma mark - UTCSEventsDataSource Implementation

@implementation UTCSEventsDataSource

- (instancetype)init
{
    if(self = [super init]) {
        self.currentFilter = @"All";
        
        self.monthDateFormatter = ({
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"MMM";
            formatter;
        });
        
        self.dayDateFormatter = ({
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"dd";
            formatter;
        });
        
        self.dateFormatter = ({
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss"; // Ex: 2014-04-19 14:27:47
            dateFormatter;
        });
        
        self.typeColorMapping = @{@"careers": [UIColor utcsEventCareersColor],
                                  @"talks"  : [UIColor utcsEventTalkColor],
                                  @"orgs"   : [UIColor utcsEventStudentOrgsColor]};
    }
    return self;
}

- (UTCSEventTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSEventTableViewCell"];
    
    if(!cell) {
        cell = [[UTCSEventTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSEventTableViewCell"];
    }
    
    UTCSEvent *event = self.filteredEvents[indexPath.row];
    cell.dayLabel.text = [self.dayDateFormatter stringFromDate:event.startDate];
    cell.monthLabel.text = [[self.monthDateFormatter stringFromDate:event.startDate]uppercaseString];
//    cell.typeColor = self.typeColorMapping[event.type];
    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = event.location;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredEvents count];
}

- (void)updateEventsWithCompletion:(UTCSEventsDataSourceCompletion)completion
{
    NSDictionary *cache = [UTCSCacheManager cacheForService:UTCSEventsService withKey:eventsCacheKey];
    UTCSCacheMetaData *metaData = cache[UTCSCacheMetaDataName];
    
    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < minimumTimeBetweenUpdates) {
        NSLog(@"Events : Cache hit");
        
        self.events = cache[UTCSCacheValuesName];
        [self filterEventsByType:self.currentFilter];
        
        if (completion) {
            completion(metaData.timestamp);
        }
        
        return;
    }
    
    NSLog(@"Events : Cache miss");
    
    [UTCSDataRequestServicer sendDataRequestWithType:UTCSDataRequestEvents argument:nil success:^(NSDictionary *meta, NSDictionary *values) {
        if ([meta[@"service"] isEqualToString:UTCSEventsService] && meta[@"success"]) {
            
            NSMutableArray *events = [NSMutableArray new];
            for (NSDictionary *eventData in values) {
                UTCSEvent *event    = [UTCSEvent new];
                event.name          = (eventData[@"name"] == [NSNull null])? nil : eventData[@"name"];
                event.contactName   = (eventData[@"contactName"] == [NSNull null])? nil : eventData[@"contactName"];
                event.contactEmail  = (eventData[@"contactEmail"] == [NSNull null])? nil : eventData[@"contactEmail"];
                event.location      = (eventData[@"location"] == [NSNull null])? nil : eventData[@"location"];
                event.description   = (eventData[@"description"] == [NSNull null])? nil : eventData[@"description"];
                event.type          = (eventData[@"type"] == [NSNull null])? nil : eventData[@"type"];
                event.link          = (eventData[@"link"] == [NSNull null])? nil : eventData[@"link"];
                
                NSString *startDateString = (eventData[@"startDate"] == [NSNull null])? nil : eventData[@"startDate"];
                event.startDate     = [self.dateFormatter dateFromString:startDateString];
                
                NSString *endDateString = (eventData[@"endDate"] == [NSNull null])? nil : eventData[@"endDate"];
                event.endDate       = [self.dateFormatter dateFromString:endDateString];
                
                event.allDay        = eventData[@"allDay"];
                event.food          = eventData[@"food"];
                
                [events addObject:event];
            }
            
            self.events = events;
            [self filterEventsByType:self.currentFilter];
            [UTCSCacheManager cacheObject:self.events forService:UTCSEventsService withKey:eventsCacheKey];
        }
        
        if (completion) {
            completion([NSDate date]);
        }
        
    } failure:^(NSError *error) {
        
        if (completion) {
            completion(metaData.timestamp);
        }
        
    }];
}

- (void)filterEventsByType:(NSString *)type
{
    if([type isEqualToString:@"All"]) {
        _filteredEvents = self.events;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", [type lowercaseString]];
        _filteredEvents = [self.events filteredArrayUsingPredicate:predicate];
    }
}

@end
