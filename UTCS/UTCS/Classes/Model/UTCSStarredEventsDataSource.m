//
//  UTCSEventsStarredDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSEvent.h"
#import "UTCSStarredEventsManager.h"
#import "UTCSStarredEventsDataSource.h"


#pragma mark - Constants

// Events table view cell identifier.
static NSString * const UTCSEventsTableViewCellIdentifier   = @"UTCSEventTableViewCell";


#pragma mark - UTCSStarredEventsDataSource Implementation

@implementation UTCSStarredEventsDataSource

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UTCSEventsTableViewCellIdentifier];
    
    if(!cell) {
        cell = [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UTCSEventsTableViewCellIdentifier];
    }
    
    UTCSEvent *event        = [[UTCSStarredEventsManager sharedManager]allEvents][indexPath.row];
    
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    NSString *detailText = [NSString string];
    
    
    if (event.startDate) {
        NSString  *dateString   = [NSDateFormatter localizedStringFromDate:event.startDate
                                                                 dateStyle:NSDateFormatterLongStyle
                                                                 timeStyle:(event.allDay)?NSDateFormatterNoStyle:NSDateFormatterShortStyle];
        
        detailText = [detailText stringByAppendingString:dateString];
        
        if ([event.location length] > 0) {
            detailText = [detailText stringByAppendingString:@"\n"];
        }
    }
    
    if ([event.location length] > 0) {
        detailText = [detailText stringByAppendingString:event.location];
    }
    
    cell.textLabel.text         = event.name;
    cell.detailTextLabel.text   = detailText;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[UTCSStarredEventsManager sharedManager]allEvents]count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UTCSEvent *event = [[UTCSStarredEventsManager sharedManager]allEvents][indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [[UTCSStarredEventsManager sharedManager]removeEvent:event];
        [tableView endUpdates];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return  @"Starred Events";
    }
    return nil;
}

@end
