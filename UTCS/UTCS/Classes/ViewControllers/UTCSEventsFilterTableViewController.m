//
//  UTCSEventsFilterTableViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsFilterTableViewController.h"

@interface UTCSEventsFilterTableViewController ()
@property (nonatomic) NSArray *filters;
@property (nonatomic) NSArray *filterColors;
@end

@implementation UTCSEventsFilterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.filters = @[@"Careers", @"Students Orgs", @"Academics"];
        self.filterColors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSEventsFilterTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UTCSEventsFilterTableViewCell"];
    }
    
    cell.textLabel.text = self.filters[indexPath.row];
    cell.accessoryView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 4.0, 4.0)];
        view.layer.cornerRadius = 2.0;
        view.layer.masksToBounds = YES;
        view.backgroundColor = self.filterColors[indexPath.row];
        view;
    });
    
    return cell;
}

@end
