//
//  UTCSDirectoryPerson.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import Foundation;


#pragma mark - UTCSDirectoryPerson Interface

/**
 UTCSDirectoryPerson is a concrete class that represents a single person.
 */
@interface UTCSDirectoryPerson : NSObject <NSCoding>

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Person's full name.
 */
@property (nonatomic) NSString *fullName;

/**
 Person's first name.
 */
@property (nonatomic) NSString *firstName;

/**
 Person's last name.
 */
@property (nonatomic) NSString *lastName;

/**
 Person's image, may be nil.
 */
@property (nonatomic) NSString *imageURL;

/**
 Location of office.
 */
@property (nonatomic) NSString *office;

/**
 Person's phone number.
 */
@property (nonatomic) NSString *phoneNumber;

/**
 Type of person (e.g. Faculty, Staff, etc.)
 */
@property (nonatomic) NSString *type;

@end
