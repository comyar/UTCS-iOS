//
//  UTCSLicenseTableViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLicenseViewController.h"
#import "UTCSLicenseDetailViewController.h"
#import "UIView+CZPositioning.h"

@interface UTCSLicenseViewController ()
@property (nonatomic) NSArray *licenses;
@property (nonatomic) UTCSLicenseDetailViewController *licenseDetailViewController;
@end

@implementation UTCSLicenseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.view.backgroundColor = [UIColor clearColor];
        self.licenses = @[@"FBShimmering", @"MBProgressHUD", @"MRCircularProgressView"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UTCSLicenseTableViewCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.0;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.licenses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSLicenseTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.licenses[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.licenseDetailViewController) {
        self.licenseDetailViewController = [UTCSLicenseDetailViewController new];
    }
    self.licenseDetailViewController.license = self.licenses[indexPath.row];
    [self.navigationController pushViewController:self.licenseDetailViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.view.width, 24)];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label.text = @"  Licenses";
        [view addSubview:label];
        view;
    });
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}

@end
