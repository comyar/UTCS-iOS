//
//  UTCSDirectoryDataSourceParser.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDirectoryDataSourceParser.h"
#import "UTCSDirectoryPerson.h"


#pragma mark - UTCSDirectoryDataSourceParser Implementation

@implementation UTCSDirectoryDataSourceParser

- (NSArray *)parseValues:(NSArray *)values
{
    NSMutableArray *directory = [NSMutableArray new];

    for (NSArray *letter in values) {
        NSMutableArray *directoryLetter = [NSMutableArray new];
        for (NSDictionary *personData in letter) {
            UTCSDirectoryPerson *person = [UTCSDirectoryPerson new];
            person.firstName    = personData[@"fName"];
            person.lastName     = personData[@"lName"];
            person.fullName     = personData[@"name"];
            person.office       = personData[@"location"];
            person.phoneNumber  = personData[@"phone"];
            person.type         = personData[@"type"];
            person.imageURL     = personData[@"image"];
            [directoryLetter addObject:person];
        }
        [directory addObject:directoryLetter];
    }
    return directory;
}

@end
