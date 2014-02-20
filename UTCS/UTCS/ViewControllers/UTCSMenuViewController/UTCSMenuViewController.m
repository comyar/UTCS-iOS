//
//  UTCSMenuViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/18/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSMenuViewController.h"


@implementation UTCSMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.imageView.tintColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor darkGrayColor];
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = @"News";
        cell.imageView.image = [[UIImage imageNamed:@"news"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    } else if(indexPath.section == 1) {
        cell.textLabel.text = @"Events";
        cell.imageView.image = [[UIImage imageNamed:@"events"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Labs";
            cell.imageView.image = [[UIImage imageNamed:@"labs"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"Directory";
        } else if(indexPath.row == 2) {
            cell.textLabel.text = @"Disk Quota";
        }
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.25 * CGRectGetHeight(self.view.bounds);
    return 0.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.textColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    } else if(section == 1) {
        return 1;
    } else if(section == 2) {
        return 2;
    } else if(section == 3) {
        return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 2) {
        return @"Tools";
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

@end
