//
//  UTCSSettingsDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsDataSource.h"
#import "UTCSTableViewCell.h"
#import "UTCSSettingsSwitchTableViewCell.h"
#import "UTCSSettingsSwitchTableViewCell.h"

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
    static NSString * const UTCSSettingsLabelTableViewCell = @"UTCSSettingsLabelTableViewCell";
//    static NSString * const UTCSSettingsSwitchTableViewCell = @"UTCSSettingsSwitchTableViewCell";
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UTCSSettingsSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsSwitchTableViewCell"];
            if (!cell) {
                cell = [[UTCSSettingsSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                             reuseIdentifier:@"UTCSSettingsSwitchTableViewCell"];
            }
            cell.textLabel.text         = @"Event Notifications";
            cell.detailTextLabel.text   = @"Get notifications an hour before the start of starred events";
            return cell;
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UTCSSettingsLabelTableViewCell];
        if (indexPath.row == 0) {
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UTCSSettingsLabelTableViewCell];
            }
            
        }
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
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
