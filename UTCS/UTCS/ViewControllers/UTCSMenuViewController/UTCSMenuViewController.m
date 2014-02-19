//
//  UTCSMenuViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/18/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSMenuViewController.h"

@interface UTCSMenuViewController ()
@property (strong, nonatomic) UITableView *menuTableView;
@end

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
    
    
    self.menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 20) style:UITableViewStyleGrouped];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTableView.dataSource = self;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.menuTableView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = @"News";
    } else if(indexPath.section == 1) {
        cell.textLabel.text = @"Events";
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Directory";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"Disk Space";
        }
    } else if(indexPath.section == 3) {
        cell.textLabel.text = @"About";
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

@end
