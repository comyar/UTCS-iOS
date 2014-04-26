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


@interface UTCSSettingsDataSource ()


@property (nonatomic) NSArray       *sectionTitles;
@property (nonatomic) NSArray       *infoTitles;

@end

@implementation UTCSSettingsDataSource

- (instancetype)init
{
    if (self = [super init]) {
        self.sectionTitles  = @[@"Settings", @"Info", @"Social"];
        self.infoTitles     = @[@"Legal", @"About"];
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
            returnCell = cell;
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsLabelTableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:@"UTCSSettingsLabelTableViewCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = self.infoTitles[indexPath.row];
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
