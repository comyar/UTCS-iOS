//
//  UTCSDirectoryManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryManager.h"
#import "UTCSDirectoryPerson.h"
#import "UTCSStateManager.h"

@interface UTCSDirectoryManager ()
@property (nonatomic) NSArray *flatDirectory;
@end

@implementation UTCSDirectoryManager

- (instancetype)init
{
    if(self = [super init]) {
        _directory = [UTCSStateManager directory];
        _flatDirectory = [UTCSStateManager flatDirectory];
    }
    return self;
}

- (void)syncDirectoryWithCompletion:(void (^)(BOOL success))completion
{

}

- (NSArray *)searchDirectoryWithSearchString:(NSString *)searchString scope:(NSString *)scope
{
    NSPredicate *predicate = nil;
    if([scope isEqualToString:@"All"]) {
        predicate = [NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) or (lastName BEGINSWITH[cd] %@) or (fullName BEGINSWITH[cd] %@)", scope, searchString, searchString, searchString];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"(type = %@) AND ((firstName BEGINSWITH[cd] %@) or (lastName BEGINSWITH[cd] %@) or (fullName BEGINSWITH[cd] %@))", scope, searchString, searchString, searchString];
    }
    NSArray *searchResults = [self.flatDirectory filteredArrayUsingPredicate:predicate];
    return searchResults;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSDirectoryTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSDirectoryTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    UTCSDirectoryPerson *person = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        
    } else {
        person = self.directory[indexPath.section][indexPath.row];
    }
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc]initWithString:person.fullName];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:cell.textLabel.font.pointSize] range:NSMakeRange(0, [person.firstName length])];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:cell.textLabel.font.pointSize] range:NSMakeRange([person.firstName length] + 1, [person.lastName length])];
    
    cell.textLabel.attributedText = attributedName;
    cell.detailTextLabel.text = person.type;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.directory[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.directory count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UTCSDirectoryPerson *person = self.directory[section][0];
    return [[person.lastName substringToIndex:1]uppercaseString];
}

@end
