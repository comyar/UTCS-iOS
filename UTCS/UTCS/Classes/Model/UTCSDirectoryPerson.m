//
//  UTCSDirectoryPerson.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryPerson.h"

@implementation UTCSDirectoryPerson

+ (UTCSDirectoryPerson *)directoryPersonWithParseObject:(PFObject *)object
{
    return [[UTCSDirectoryPerson alloc]initWithParseObject:object];
}

- (instancetype)initWithParseObject:(PFObject *)object
{
    if(self = [super init]) {
        _fullName = object[@"name"];
        _firstName = object[@"fName"];
        _lastName = object[@"lName"];
        _officeLocation = object[@"location"];
        _phoneNumber = object[@"phone"];
        _type = [self typeForParseType:object[@"type"]];
    }
    return self;
}

- (NSString *)typeForParseType:(NSString *)parseType
{
    if([parseType isEqualToString:@"grad"]) {
        return @"Graduate";
    }
    return [parseType capitalizedString];
}

@end
