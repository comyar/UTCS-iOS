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


#pragma mark - Constants

// Key used to cache events
static NSString * const eventsCacheKey      = @"events";

// Minimum time between updates, in seconds
static CGFloat minimumTimeBetweenUpdates    = 10800.0;  // 3 hours


#pragma mark - UTCSEventsDataSoure Class Extension

@interface UTCSEventsDataSource ()

// Array of all the events
@property (nonatomic) NSArray           *events;

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
        self.parser = [UTCSEventsDataSourceParser new];
        self.cache  = [[UTCSDataSourceCache alloc]initWithService:service];
        
        self.minimumTimeBetweenUpdates = minimumTimeBetweenUpdates;
        
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

- (UTCSEventTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSEventTableViewCell"];
    
    if(!cell) {
        cell = [[UTCSEventTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSEventTableViewCell"];
    }
    
    UTCSEvent *event        = self.data[indexPath.row];
    cell.dayLabel.text      = [self.dayDateFormatter stringFromDate:event.startDate];
    cell.monthLabel.text    = [[self.monthDateFormatter stringFromDate:event.startDate]uppercaseString];
    
    UIColor *typeColor      = self.typeColorMapping[event.type];
    cell.typeStripeLayer.fillColor = (typeColor) ? typeColor.CGColor : [UIColor whiteColor].CGColor;

    cell.textLabel.text         = event.name;
    cell.detailTextLabel.text   = event.location;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

@end
