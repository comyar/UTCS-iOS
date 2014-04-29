//
//  UTCSEvent.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;
@import EventKit;

/**
 */
@interface UTCSEvent : NSObject <NSCoding>

// -----
// @name Properties
// -----

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
@property (nonatomic) BOOL                  starred;

@end
