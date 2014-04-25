//
//  UTCSSettingsDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsDataSource.h"
#import "UTCSTableViewCell.h"

@interface UTCSSettingsDataSource ()


@property (nonatomic) NSArray       *sectionTitles;
@property (nonatomic) NSArray       *infoTitles;

@end

@implementation UTCSSettingsDataSource

- (instancetype)init
{
    if (self = [super init]) {
        self.sectionTitles = @[@"App", @"Info", @"Social"];
        self.infoTitles = @[@"Legal", @"About"];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsTableViewCell"];
    if (!cell) {
        cell = [[UTCSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UTCSSettingsTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.infoTitles[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 2) {
        
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self.infoTitles count];
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionTitles count];
}

@end
