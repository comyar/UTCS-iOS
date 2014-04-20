//
//  UTCSDirectoryPerson.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryPerson.h"

@implementation UTCSDirectoryPerson

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        _fullName       = [aDecoder decodeObjectForKey:@"name"];
        _firstName      = [aDecoder decodeObjectForKey:@"fName"];
        _lastName       = [aDecoder decodeObjectForKey:@"lName"];
        _office         = [aDecoder decodeObjectForKey:@"office"];
        _phoneNumber    = [aDecoder decodeObjectForKey:@"phone"];
        _type           = [aDecoder decodeObjectForKey:@"type"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_fullName          forKey:@"name"];
    [aCoder encodeObject:_firstName         forKey:@"fName"];
    [aCoder encodeObject:_lastName          forKey:@"lName"];
    [aCoder encodeObject:_office            forKey:@"office"];
    [aCoder encodeObject:_phoneNumber       forKey:@"phone"];
    [aCoder encodeObject:_type              forKey:@"type"];
}

@end
