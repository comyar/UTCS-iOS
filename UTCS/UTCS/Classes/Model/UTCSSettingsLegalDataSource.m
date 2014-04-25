//
//  UTCSSettingsLegalDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsLegalDataSource.h"
#import "UTCSBouncyTableViewCell.h"

@interface UTCSSettingsLegalDataSource ()
@property (nonatomic) NSArray *sectionTitles;
@property (nonatomic) NSArray *licenses;
@end


@implementation UTCSSettingsLegalDataSource

- (instancetype)init
{
    if (self = [super init]) {
        self.sectionTitles = @[@"Licenses"];
        self.licenses = @[@"AFNetworking", @"FBShimmering", @"MBProgressHUD", @"MRCircularProgressView", @"JVFloatLabeledTextField"];
    }
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSBouncyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsLegalTableViewCell"];
    if (!cell) {
        cell = [[UTCSBouncyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSSettingsLegalTableViewCell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.licenses[indexPath.row];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.licenses count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.sectionTitles[section];
    }
    return nil;
}

@end
