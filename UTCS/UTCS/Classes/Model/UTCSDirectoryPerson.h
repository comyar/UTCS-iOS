//
//  UTCSDirectoryPerson.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

@interface UTCSDirectoryPerson : NSObject <NSCoding>

@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSString *office;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSString *type;

@end
