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


#pragma mark - Constants

// Key for the person's first name
static NSString * const firstNameKey    = @"fName";

// Key for the person's last name
static NSString * const lastNameKey     = @"lName";

// Key for the person's full name
static NSString * const fullNameKey     = @"name";

// Key for the person's office location
static NSString * const officeKey       = @"location";

// Key for the person's phone number
static NSString * const phoneKey        = @"phone";

// Key for the person's type
static NSString * const typeKey         = @"type";

// Key for the person's image URL
static NSString * const imageURLKey     = @"image";


#pragma mark - UTCSDirectoryDataSourceParser Implementation

@implementation UTCSDirectoryDataSourceParser

- (NSArray *)parseValues:(NSArray *)values
{
    NSMutableArray *directory = [NSMutableArray new];

    for (NSArray *letter in values) {
        NSMutableArray *directoryLetter = [NSMutableArray new];
        for (NSDictionary *personData in letter) {
            UTCSDirectoryPerson *person = [UTCSDirectoryPerson new];
            person.firstName    = personData[firstNameKey];
            person.lastName     = personData[lastNameKey];
            person.fullName     = personData[fullNameKey];
            person.office       = personData[officeKey];
            person.phoneNumber  = personData[phoneKey];
            person.type         = personData[typeKey];
            person.imageURL     = personData[imageURLKey];
            [directoryLetter addObject:person];
        }
        [directory addObject:directoryLetter];
    }
    
    return directory;
}

@end
