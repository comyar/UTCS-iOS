//
//  UTCSSettingsDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsDataSource.h"
#import "UTCSBouncyTableViewCell.h"
#import "UTCSSwitchTableViewCell.h"
#import "UTCSSegmentedControlTableViewCell.h"
#import "UTCSStateManager.h"

@interface UTCSSettingsDataSource ()


@property (nonatomic) NSArray       *sectionTitles;
@property (nonatomic) NSArray       *infoTitles;
@property (nonatomic) NSArray       *socialTitles;

@end

@implementation UTCSSettingsDataSource

- (instancetype)init
{
    if (self = [super init]) {
        self.sectionTitles  = @[@"Settings", @"Info", @"Social"];
        self.infoTitles     = @[@"Legal", @"About"];
        self.socialTitles   = @[@"Facebook", @"Twitter"];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UTCSSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsSwitchTableViewCell"];
            if (!cell) {
                cell = [[UTCSSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                             reuseIdentifier:@"UTCSSettingsSwitchTableViewCell"];
                
            }
            [cell.cellSwitch addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
            cell.cellSwitch.selected = [UTCSStateManager sharedManager].eventNotifications;
            cell.cellSwitch.tag = 0;
            cell.textLabel.text         = @"Event Notifications";
            cell.detailTextLabel.text   = @"Get notifications an hour before the start of starred events";
            returnCell = cell;
        } else if (indexPath.row == 1) {
            UTCSSegmentedControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsSegmentedControlSTableViewCell"];
            if (!cell) {
                cell = [[UTCSSegmentedControlTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                               reuseIdentifier:@"UTCSSettingsSegmentedControlSTableViewCell"];
            }
            cell.textLabel.text = @"Preferred Lab";
            cell.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Third Floor", @"Basement"]];
            [cell.segmentedControl addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
            cell.segmentedControl.selectedSegmentIndex = [UTCSStateManager sharedManager].preferredLab;
            cell.segmentedControl.tag = 1;
            returnCell = cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsLabelTableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"UTCSSettingsLabelTableViewCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        }

        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.infoTitles[indexPath.row];
            cell.imageView.image = nil;
        } else if (indexPath.section == 2) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.socialTitles[indexPath.row];
            NSString *imageName = [self.socialTitles[indexPath.row]lowercaseString];
            cell.imageView.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.imageView.tintColor = [UIColor whiteColor];
        }
        returnCell = cell;
    }
    return returnCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return [self.infoTitles count];
    } else if (section == 2) {
        return [self.socialTitles count];
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

#pragma mark 

- (void)didChangeValue:(UIControl *)control
{
    if (control.tag == 0) {
        [UTCSStateManager sharedManager].eventNotifications = ((UISwitch *)control).selected;
    } else if (control.tag == 1) {
        [UTCSStateManager sharedManager].preferredLab = ((UISegmentedControl *)control).selectedSegmentIndex;
    }
}


@end
