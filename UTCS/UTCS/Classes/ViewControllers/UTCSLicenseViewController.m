//
//  UTCSLicenseTableViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLicenseViewController.h"
#import "UTCSLicenseDetailViewController.h"

@interface UTCSLicenseViewController ()
@property (nonatomic) NSArray *licenses;
@property (nonatomic) UTCSLicenseDetailViewController *licenseDetailViewController;
@end

@implementation UTCSLicenseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.licenses = @[@"FBShimmering", @"MBProgressHUD", @"MRCircularProgressView"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UTCSLicenseTableViewCell"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

@end
