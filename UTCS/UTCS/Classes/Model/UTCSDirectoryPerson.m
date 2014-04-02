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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        _fullName = [aDecoder valueForKey:@"name"];
        _firstName = [aDecoder valueForKey:@"fName"];
        _lastName = [aDecoder valueForKey:@"lName"];
        _officeLocation = [aDecoder valueForKey:@"location"];
        _phoneNumber = [aDecoder valueForKey:@"phone"];
        _type = [aDecoder valueForKey:@"type"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_fullName forKey:@"name"];
    [aCoder encodeObject:_firstName forKey:@"fName"];
    [aCoder encodeObject:_lastName forKey:@"lName"];
    [aCoder encodeObject:_officeLocation forKey:@"location"];
    [aCoder encodeObject:_phoneNumber forKey:@"phone"];
    [aCoder encodeObject:_type forKey:@"type"];
}

@end
