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
#import "UTCSEventsDataSource.h"
#import "UTCSDataRequestServicer.h"
#import "UTCSDataSourceCache.h"
#import "UTCSEventsDataSourceParser.h"

// Views
#import "UTCSEventTableViewCell.h"

// Categories
#import "UIColor+UTCSColors.h"


NSString * const UTCSEventsFilterRemoveName     = @"UTCSEventsFilterRemoveName";
NSString * const UTCSEventsFilterAddName        = @"UTCSEventsFilterAddName";
NSString * const UTCSEventsDataSourceCacheKey   = @"UTCSEventsDataSourceCacheKey";

#pragma mark - Constants

// Key used to cache events
static NSString * const eventsCacheKey      = @"events";

// Minimum time between updates, in seconds
static CGFloat minimumTimeBetweenUpdates    = 10800.0;  // 3 hours


#pragma mark - UTCSEventsDataSoure Class Extension

@interface UTCSEventsDataSource ()

//
@property (nonatomic) NSString          *currentFilterType;

//
@property (nonatomic) NSMutableArray    *filteredEvents;

// Date formatter for a 3-letter month name
@property (nonatomic) NSDateFormatter   *monthDateFormatter;

// Date formatter for a zero-padded day of the month
@property (nonatomic) NSDateFormatter   *dayDateFormatter;

// Mapping between event type to color
@property (nonatomic) NSDictionary      *typeColorMapping;

// Date formatter
@property (nonatomic) NSDateFormatter   *dateFormatter;

@end


#pragma mark - UTCSEventsDataSource Implementation

@implementation UTCSEventsDataSource

- (instancetype)initWithService:(NSString *)service
{
    if(self = [super initWithService:service]) {
        _parser = [UTCSEventsDataSourceParser new];
        _cache  = [[UTCSDataSourceCache alloc]initWithService:service];
        
        _minimumTimeBetweenUpdates = minimumTimeBetweenUpdates;
        
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
        
        self.typeColorMapping = @{@"careers": [UIColor utcsEventCareersColor],
                                  @"talks"  : [UIColor utcsEventTalkColor],
                                  @"orgs"   : [UIColor utcsEventStudentOrgsColor]};
    }
    return self;
}

#pragma mark Filtering

- (void)prepareFilter
{
    self.filteredEvents = [self.data mutableCopy];
}

- (NSDictionary *)filterEventsWithType:(NSString *)type
{
    NSMutableArray *add     = [NSMutableArray new];
    NSMutableArray *remove  = [NSMutableArray new];
    
    type = [type lowercaseString];
    
    if ([type isEqualToString:@"all"]) {
        
        // Pretty inefficient but I'm lazy #yolo
        for (UTCSEvent *event in self.data) {
            if (![self.filteredEvents containsObject:event]) {
                NSIndexPath *indexPath = nil;
                for (int i = 0; [self.filteredEvents count]; ++i) {
                    UTCSEvent *filterEvent = self.filteredEvents[i];
                    if ([filterEvent.startDate timeIntervalSinceDate:event.startDate] <= 0.0) {
                        [self.filteredEvents insertObject:event atIndex:i];
                        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        break;
                    }
                }
                
                if (!indexPath) {
                    indexPath = [NSIndexPath indexPathForRow:[self.filteredEvents count] inSection:0];
                    [self.filteredEvents addObject:event];
                }
                [add addObject:indexPath];
            }
        }
        
        self.filteredEvents = [self.data mutableCopy];
        
    } else {
        
        for (int i = 0; i < [self.filteredEvents count]; ++i) {
            UTCSEvent *event = self.filteredEvents[i];
            if (![event.type isEqualToString:type]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [remove addObject:indexPath];
                [self.filteredEvents removeObject:event];
            }
        }
        
        for (int i = 0; i < [self.data count]; ++i) {
            UTCSEvent *event = self.data[i];
            
            if ([event.type isEqualToString:type] && ![self.filteredEvents containsObject:event]) {
                NSIndexPath *indexPath = nil;
                for (int i = 0; [self.filteredEvents count]; ++i) {
                    UTCSEvent *filterEvent = self.filteredEvents[i];
                    if ([filterEvent.startDate timeIntervalSinceDate:event.startDate] <= 0.0) {
                        [self.filteredEvents insertObject:event atIndex:i];
                        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        break;
                    }
                }
                
                if (!indexPath) {
                    indexPath = [NSIndexPath indexPathForRow:[self.filteredEvents count] inSection:0];
                    [self.filteredEvents addObject:event];
                }
                [add addObject:indexPath];
            }
            
        }
        
    }
    
    self.currentFilterType = type;
    
    return @{UTCSEventsFilterAddName    : add,
             UTCSEventsFilterRemoveName : remove};
}

#pragma mark UITableViewDataSource Methods

- (UTCSEventTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSEventTableViewCell"];
    
    if(!cell) {
        cell = [[UTCSEventTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSEventTableViewCell"];
    }
    
    UTCSEvent *event        = self.filteredEvents[indexPath.row];
    
    UIColor *typeColor = self.typeColorMapping[event.type];
    cell.typeStripeLayer.fillColor = typeColor.CGColor;
    
    
    NSString *detailText = [NSString string];
    
    if ([event.location length] > 0) {
        detailText = [detailText stringByAppendingString:event.location];
        if (event.startDate) {
            detailText = [detailText stringByAppendingString:@"\n"];
        }
    }
    
    if (event.startDate) {
        NSString  *dateString   = [NSDateFormatter localizedStringFromDate:event.startDate
                                                                 dateStyle:NSDateFormatterLongStyle
                                                                 timeStyle:NSDateFormatterShortStyle];
        detailText = [detailText stringByAppendingString:dateString];
    }
    
    cell.textLabel.text         = event.name;
    cell.detailTextLabel.text   = detailText;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredEvents count];
}

@end
