//
//  UTCSEvent.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import Foundation;
@import EventKit;


#pragma mark - UTCSEvent Interface

/**
 UTCSEvent is a concrete class that represents a single UTCS event.
 */
@interface UTCSEvent : NSObject <NSCoding>

// -----
// @name Properties
// -----

#pragma mark - Properties

/**
 */
@property (nonatomic) NSString              *name;

/**
 */
@property (nonatomic) NSString              *contactName;

/**
 */
@property (nonatomic) NSString              *contactEmail;

/**
 */
@property (nonatomic) NSString              *location;

/**
 */
@property (nonatomic) NSString              *description;

/**
 */
@property (nonatomic) NSAttributedString    *attributedDescription;

/**
 */
@property (nonatomic) NSString              *type;

/**
 */
@property (nonatomic) NSString              *link;

/**
 */
@property (nonatomic) NSDate                *startDate;

/**
 */
@property (nonatomic) NSDate                *endDate;

/**
 */
@property (nonatomic) BOOL                  allDay;

/**
 */
@property (nonatomic) BOOL                  food;

/**
 */
@property (nonatomic) EKEvent               *calendarEvent;

/**
 */
@property (nonatomic) NSString              *eventID;

@end
