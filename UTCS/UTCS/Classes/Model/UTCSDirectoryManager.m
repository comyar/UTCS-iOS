//
//  UTCSDirectoryManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryManager.h"
#import "UTCSDirectoryPerson.h"

@implementation UTCSDirectoryManager


- (void)syncDirectoryWithCompletion:(void (^)(BOOL success))completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"DirectoryItem"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects) {
            
            NSMutableDictionary *directory = [NSMutableDictionary new];
            
            for(PFObject *object in objects) {
                UTCSDirectoryPerson *person = [UTCSDirectoryPerson directoryPersonWithParseObject:object];
                NSString *firstChar = [[person.lastName substringToIndex:1]uppercaseString];
                if(!firstChar) {
                    continue;
                }
                if(directory[firstChar]) {
                    NSMutableArray *peopleWithFirstLetter = directory[firstChar];
                    NSUInteger insertionIndex = [peopleWithFirstLetter indexOfObject:person inSortedRange:NSMakeRange(0, [peopleWithFirstLetter count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
                        
                        return [((UTCSDirectoryPerson *)obj1).firstName
                                compare:((UTCSDirectoryPerson *)obj2).firstName
                                options:NSCaseInsensitiveSearch];
                    }];
                    [peopleWithFirstLetter insertObject:person atIndex:insertionIndex];
                } else {
                    NSMutableArray *peopleWithFirstLetter = [NSMutableArray new];
                    [peopleWithFirstLetter addObject:person];
                    directory[firstChar] = peopleWithFirstLetter;
                }
            }
            
            NSArray *sortedKeys = [[directory allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
            }];
            
            NSMutableArray *sortedPeople = [NSMutableArray new];
            for(NSString *key in sortedKeys) {
                [sortedPeople addObject:directory[key]];
            }
            
            _directoryPeople = sortedPeople;
            
            if(completion) {
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UTCSDirectoryPerson *person = self.directoryPeople[indexPath.section][indexPath.row];
    
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc]initWithString:person.fullName];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:cell.textLabel.font.pointSize] range:NSMakeRange(0, [person.firstName length])];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:cell.textLabel.font.pointSize] range:NSMakeRange([person.firstName length] + 1, [person.lastName length])];
    
    cell.textLabel.attributedText = attributedName;
    cell.detailTextLabel.text = person.type;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.directoryPeople[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.directoryPeople count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UTCSDirectoryPerson *person = self.directoryPeople[section][0];
    return [[person.lastName substringToIndex:1]uppercaseString];
}


@end
