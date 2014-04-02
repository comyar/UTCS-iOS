//
//  UTCSDirectoryPerson.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UTCSDirectoryPerson : NSObject <NSCoding>

+ (UTCSDirectoryPerson *)directoryPersonWithParseObject:(PFObject *)object;

- (instancetype)initWithParseObject:(PFObject *)object;

@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *officeLocation;
@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic, readonly) NSString *type;

@end
