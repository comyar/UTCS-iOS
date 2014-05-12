//
//  UTCSEventsStarredDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSStarredEventsDataSource.h"
#import "UTCSEvent.h"
#import "UTCSStarredEventManager.h"
#import "UTCSEventTableViewCell.h"

@implementation UTCSStarredEventsDataSource

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSEventTableViewCell"];
    
    if(!cell) {
        cell = [[UTCSEventTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSEventTableViewCell"];
    }
    
    UTCSEvent *event        = [[UTCSStarredEventManager sharedManager]allEvents][indexPath.row];
    
    cell.typeStripeLayer.fillColor = [UIColor clearColor].CGColor;
    
    
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

    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[UTCSStarredEventManager sharedManager].allEvents count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
