//
//  UTCSEventsFilterTableViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsFilterTableViewController.h"
#import "FXBlurView.h"
#import "UIView+CZPositioning.h"

@interface UTCSEventsFilterTableViewController ()
@property (nonatomic) NSArray *filters;
@property (nonatomic) NSArray *filterColors;
@property (nonatomic) FXBlurView *blurView;
@property (nonatomic) UITableView *tableView;
@end

@implementation UTCSEventsFilterTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.filters = @[@"Careers", @"Students Orgs", @"Academics"];
        self.filterColors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
        self.blurView = ({
            FXBlurView *blurView = [[FXBlurView alloc]initWithFrame:self.view.bounds];
            blurView.tintColor = [UIColor blackColor];
            blurView.blurRadius = 20.0;
            blurView.layer.cornerRadius = 8.0;
            blurView.layer.masksToBounds = YES;
            blurView;
        });
        [self.view addSubview:self.blurView];
        
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.25];
            tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.1];
            tableView.tableHeaderView = ({
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.tableView.width, 44)];
                label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.text = @"Filter";
                label;
            });
            tableView.layer.cornerRadius = 8.0;
            tableView.layer.masksToBounds = YES;
            tableView.dataSource = self;
            tableView;
        });
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.blurView.frame = self.view.bounds;
    self.tableView.frame = self.view.bounds;
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
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        cell.textLabel.textColor = [UIColor whiteColor];
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
