class SettingsAboutViewController: TableViewController {

}


/*
//
//  UTCSSettingsAboutViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsAboutViewController.h"

@interface UTCSSettingsAboutViewController ()
@property (nonatomic) NSArray *sectionTitles;

@end

@implementation UTCSSettingsAboutViewController

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
self.tableView.dataSource = self;
self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

self.sectionTitles = @[@"About", @"Version"];
}
return self;
}

- (void)viewWillAppear:(BOOL)animated
{
[super viewWillAppear:animated];
[self.navigationController setNavigationBarHidden:NO animated:YES];
self.menuButton.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
if (indexPath.row == 0 && indexPath.section == 0) {
return 200.0;
}
return 36.0;
}

#pragma mark UITableViewDataSource Methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
BouncyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsLegalTableViewCell"];
if (!cell) {
cell = [[BouncyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSSettingsLegalTableViewCell"];
}

cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

if (indexPath.section == 0) {
cell.textLabel.numberOfLines = 0;
cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];

cell.textLabel.text = @"The UTCS app was developed by Comyar Zaheri under the direction of the Department of Computer Science. The
app is updated and maintained by Mobile App Development (MAD), a
student organization in the Department of Computer Science at the University of Texas at Austin.";
} else if (indexPath.section == 1) {
cell.textLabel.numberOfLines = 0;
cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
cell.textLabel.textAlignment = NSTextAlignmentCenter;
cell.textLabel.text = @"v1.0 Beta, © 2014 UTCS";
}

return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
if (section == 0) {
return 1;
} else if (section == 1) {
return 1;
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

@end
*/
