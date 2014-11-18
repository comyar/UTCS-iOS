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
 Event name.
 */
@property (nonatomic) NSString              *name;

/**
 Contact name for the event.
 */
@property (nonatomic) NSString              *contactName;

/**
 Contact email for the event.
 */
@property (nonatomic) NSString              *contactEmail;

/**
 Location of the event.
 */
@property (nonatomic) NSString              *location;

/**
 Event description.
 */
@property (nonatomic) NSString              *eventDescription;

/**
 Attributed description of the event.
 */
@property (nonatomic) NSAttributedString    *attributedDescription;

/**
 Event type. (e.g. Talks, Careers, etc.)
 */
@property (nonatomic) NSString              *type;

/**
 Link to the event on UTCS site.
 */
@property (nonatomic) NSString              *link;

/**
 Start date of the event.
 */
@property (nonatomic) NSDate                *startDate;

/**
 End date of the event.
 */
@property (nonatomic) NSDate                *endDate;

/**
 YES if the event is all day.
 */
@property (nonatomic) BOOL                  allDay;

/**
 YES if the event provides food.
 */
@property (nonatomic) BOOL                  food;

/**
 Unique ID for the event.
 */
@property (nonatomic) NSString              *eventID;

@end
