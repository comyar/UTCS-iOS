//
//  UTCSSettingsLicenseViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsLicenseViewController.h"

@interface UTCSSettingsLicenseViewController ()

@end

@implementation UTCSSettingsLicenseViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setLicense:(NSString *)license
{
    _license = license;
    NSLog(@"license set : %@", _license);
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.menuButton.hidden = YES;
}

#pragma mark UITableViewDataSource Methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsLicenseTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"UTCSSettingsLicenseTableViewCell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    NSString *licenseFilename = [self.license stringByAppendingString:@"-license"];
    NSLog(@"license : %@", licenseFilename);
    NSString *licensePath = [[NSBundle mainBundle]pathForResource:licenseFilename ofType:@"txt"];
    NSLog(@"license path : %@", licensePath);
    
    cell.textLabel.text = [NSString stringWithContentsOfFile:licensePath encoding:NSUTF32StringEncoding error:nil];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.license;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
