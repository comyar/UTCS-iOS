//
//  UTCSSettingsLegalViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsLegalViewController.h"
#import "UTCSSettingsLicenseViewController.h"
#import "UTCSBouncyTableViewCell.h"


@interface UTCSSettingsLegalViewController ()
@property (nonatomic) NSArray *sectionTitles;
@property (nonatomic) NSArray *licenses;
@property (nonatomic) NSArray *photographs;
@property (nonatomic) UTCSSettingsLicenseViewController *licenseViewController;

@end

@implementation UTCSSettingsLegalViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.licenseViewController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.menuButton.hidden = YES;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 50.0;
        
        self.sectionTitles = @[@"Licenses", @"Photographs By"];
        self.licenses = @[@"POP", @"FBTweaks", @"FBShimmering",
                          @"AFNetworking", @"MBProgressHUD", @"JVFloatLabeledTextField",
                          @"DPMeterView", @"IntentKit", @"PocketSVG"];
        
        self.photographs = @[@"Keerthana Kumar",
                             @"Comyar Zaheri",
                             @"Michael Brennan",
                             @"Jaclyn Kachelmeyer",
                             @"Department of Computer Science"];
    }
    return self;
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSBouncyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsLegalTableViewCell"];
    if (!cell) {
        cell = [[UTCSBouncyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSSettingsLegalTableViewCell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.licenses[indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.photographs[indexPath.row];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.licenses count];
    } else if (section == 1) {
        return [self.photographs count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *license = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if (!self.licenseViewController) {
        self.licenseViewController = [UTCSSettingsLicenseViewController new];
    }
    self.licenseViewController.license = license;
    [self.navigationController pushViewController:self.licenseViewController animated:YES];
}

@end
