//
//  UTCSEventsFilterTableViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsFilterTableViewController.h"
#import "UIView+CZPositioning.h"
#import "UIColor+UTCSColors.h"

@interface UTCSEventsFilterTableViewController ()
@property (nonatomic) NSArray *filters;
@property (nonatomic) NSArray *filterColors;
@property (nonatomic) UITableView *tableView;
@end

@implementation UTCSEventsFilterTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.filters = @[@"All", @"Careers", @"Talks", @"Students Orgs"];
        self.filterColors = @[[UIColor clearColor],
                              [UIColor utcsEventCareersColor],
                              [UIColor utcsEventTalkColor],
                              [UIColor utcsEventStudentOrgsColor]];
        
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.1];
            tableView.rowHeight = 44;
            tableView.tableHeaderView = ({
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.tableView.width, 44)];
                label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor darkGrayColor];
                label.text = @"Filter";
                label;
            });
            tableView.layer.cornerRadius = 8.0;
            tableView.layer.masksToBounds = YES;
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView;
        });
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate eventsFilterTableViewController:self didSelectFilter:self.filters[indexPath.row]];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSEventsFilterTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UTCSEventsFilterTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    cell.textLabel.text = self.filters[indexPath.row];
    cell.accessoryView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 8.0, 8.0)];
        view.layer.cornerRadius = 4.0;
        view.layer.masksToBounds = YES;
        view.backgroundColor = self.filterColors[indexPath.row];
        view;
    });
    
    return cell;
}

@end
