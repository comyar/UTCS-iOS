//
//  UTCSLabsManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsManager.h"
#import "UTCSLabsTableViewCell.h"

@implementation UTCSLabsManager

- (UTCSLabsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSLabsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSLabsTableViewCell"];
    if(!cell) {
        cell = [[UTCSLabsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UTCSLabsTableViewCell"];
    }
    
    cell.textLabel.text = @"weretaco";
    cell.detailTextLabel.text = @"Basement";
    cell.occupiedLabel.text = @"Unoccupied";
    cell.indicatorColor = [UIColor greenColor];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

@end
