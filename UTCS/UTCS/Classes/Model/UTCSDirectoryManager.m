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
@property (nonatomic) NSArray *searchResults;
@end

@implementation UTCSDirectoryManager


- (instancetype)init
{
    if(self = [super init]) {
        _directory = [UTCSStateManager directory];
    }
    return self;
}

- (void)syncDirectoryWithCompletion:(void (^)(BOOL success))completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"DirectoryItem"];
    query.limit = 1000;
    [query orderByAscending:@"lName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *directoryPeople = [NSMutableArray new];
        if(objects) {
            NSString *lastChar = nil;
            for(PFObject *object in objects) {
                UTCSDirectoryPerson *person = [UTCSDirectoryPerson directoryPersonWithParseObject:object];
                if(!person.fullName ||
                   [person.firstName isEqualToString:@"undergrad"] ||
                   [person.firstName isEqualToString:@"post"] ||
                   [person.firstName isEqualToString:@"visitor"]) {
                    continue;
                }
                
                NSString *firstChar = [person.lastName substringToIndex:1];
                if([firstChar isEqualToString:lastChar]) {
                    NSMutableArray *letter = [directoryPeople lastObject];
                    if(!letter) {
                        letter = [NSMutableArray new];
                    }
                    [letter addObject:person];
                } else {
                    NSMutableArray *letter = [NSMutableArray new];
                    [letter addObject:person];
                    [directoryPeople addObject:letter];
                    lastChar = firstChar;
                }
            }
            _directory = directoryPeople;
            if(completion) {
                [UTCSStateManager setDirectory:_directory];
                completion(YES);
            }
        } else {
            if(completion) {
                completion(NO);
            }
        }
    }];
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
        person = self.searchResults[indexPath.section][indexPath.row];
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

- (void)setSearchDisplayController:(UISearchDisplayController *)searchDisplayController
{
    _searchDisplayController = searchDisplayController;
    _searchDisplayController.delegate = self;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName like[cd] %@", searchString];
    NSMutableArray *filteredPeople = [NSMutableArray new];
    for(NSArray *peopleForLetter in self.directory) {
        [filteredPeople addObject:[peopleForLetter filteredArrayUsingPredicate:predicate]];
    }
    self.searchResults = filteredPeople;
    return YES;
}

@end
