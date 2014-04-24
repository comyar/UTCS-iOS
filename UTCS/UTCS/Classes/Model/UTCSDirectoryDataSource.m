//
//  UTCSDirectoryManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

#import "UTCSDirectoryDataSource.h"
#import "UTCSDirectoryPerson.h"
#import "UTCSDirectoryDataSourceParser.h"
#import "UTCSDataSourceCache.h"
#import "UTCSDirectoryTableViewCell.h"
#import "UTCSDirectoryDataSourceSearchController.h"

#pragma mark - Constants


#pragma mark - UTCSDirectoryDataSource Class Extension

@interface UTCSDirectoryDataSource ()

@property (nonatomic) NSArray *flatDirectory;

@end


#pragma mark - UTCSDirectoryDataSource Implementation

@implementation UTCSDirectoryDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        self.minimumTimeBetweenUpdates = 2592000.0;  // 30 days
        self.cache = [[UTCSDataSourceCache alloc]initWithService:service];
        self.parser = [UTCSDirectoryDataSourceParser new];
        self.searchController = [UTCSDirectoryDataSourceSearchController new];
        self.searchController.dataSource = self;
    }
    return self;
}

- (void)buildFlatDirectory
{
    NSMutableArray *flatDirectory = [NSMutableArray new];
    for (NSArray *letter in self.data) {
        for (UTCSDirectoryPerson *person in letter) {
            [flatDirectory addObject:person];
        }
    }
    _flatDirectory = flatDirectory;
}

- (UTCSDirectoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSDirectoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSDirectoryTableViewCell"];
    if(!cell) {
        cell = [[UTCSDirectoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSDirectoryTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UTCSDirectoryPerson *person = self.data[indexPath.section][indexPath.row];
    
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc]initWithString:person.fullName];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:cell.textLabel.font.pointSize] range:NSMakeRange(0, [person.firstName length])];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:cell.textLabel.font.pointSize] range:NSMakeRange([person.firstName length] + 1, [person.lastName length])];
    
    cell.textLabel.attributedText = attributedName;
    cell.detailTextLabel.text = person.type;
    cell.phoneNumberTextView.text = (person.phoneNumber)? [NSString stringWithFormat:@"Phone: %@", person.phoneNumber] : @"";
    cell.officeLabel.text = (person.office)? [NSString stringWithFormat:@"Office: %@", person.office] : @"";

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *letters = [NSMutableArray new];
    for (NSArray *letter in self.data) {
        UTCSDirectoryPerson *person = letter[0];
        NSString *firstLetter = [[person.lastName substringToIndex:1]uppercaseString];
        [letters addObject:firstLetter];
    }
    return letters;
}

@end
