//
//  UTCSEventsDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsDataSource.h"
#import "UTCSEvent.h"
#import "UTCSEventTableViewCell.h"
#import "UIColor+UTCSColors.h"


typedef void (^ UTCSEventManagerCompletion) (NSArray *events, NSError *error);


const NSTimeInterval kEarliestTimeIntervalForEvents             = -86400;

NSString * const UTCSParseClassEvent                            = @"Event";


@interface UTCSEventsDataSource ()
@property (nonatomic) NSArray *events;
@property (nonatomic) NSDateFormatter   *monthDateFormatter;
@property (nonatomic) NSDateFormatter   *dayDateFormatter;
@property (nonatomic) NSDictionary      *tagColorMapping;
@end


@implementation UTCSEventsDataSource

- (instancetype)init
{
    if(self = [super init]) {
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
        
        
        self.tagColorMapping = @{@"careers": [UIColor utcsEventCareersColor],
                                 @"talks":[UIColor utcsEventTalkColor],
                                 @"orgs":[UIColor utcsEventStudentOrgsColor]};
    }
    return self;
}

- (UTCSEventTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSEventTableViewCell"];
    if(!cell) {
        cell = [[UTCSEventTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSEventTableViewCell"];
    }
    
    cell.selected = NO;
    cell.highlighted = NO;
    
    UTCSEvent *event = self.events[indexPath.row];
    cell.dayLabel.text = [self.dayDateFormatter stringFromDate:event.startDate];
    cell.monthLabel.text = [[self.monthDateFormatter stringFromDate:event.startDate]uppercaseString];
//    cell.tagColor = self.tagColorMapping[event.tag];
    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = event.location;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredEvents count];
}

- (void)updateEventsWithCompletion:(void (^)(void))completion
{
    [self eventsWithCompletion:^(NSArray *events, NSError *error) {
        if(events) {
            self.events = events;
            if(!self.filteredEvents) {
                _filteredEvents = self.events;
            }
        }
        if(completion) {
            completion();
        }
    }];
}

- (void)filterEventsWithTag:(NSString *)tag
{
    if([tag isEqualToString:@"All"]) {
        _filteredEvents = self.events;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag = %@", [tag lowercaseString]];
        _filteredEvents = [self.events filteredArrayUsingPredicate:predicate];
    }
}

- (void)eventsWithCompletion:(UTCSEventManagerCompletion)completion
{


}



@end
