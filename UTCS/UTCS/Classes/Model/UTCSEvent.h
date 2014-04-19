//
//  UTCSEvent.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UTCSParseEventName;
extern NSString * const UTCSParseEventContactName;
extern NSString * const UTCSParseEventContactEmail;
extern NSString * const UTCSParseEventLocation;
extern NSString * const UTCSParseEventHTMLDescription;
extern NSString * const UTCSParseEventStartDate;
extern NSString * const UTCSParseEventEndDate;

extern NSString *const UTCSEventDetailBoldFont;
extern NSString *const UTCSEventDetailBoldColor;
extern NSString *const UTCSEventDetailNormalFont;
extern NSString *const UTCSEventDetailNormalColor;


/**
 */
@interface UTCSEvent : NSObject


/**
 */
@property (strong, nonatomic) NSString            *name;

/**
 */
@property (strong, nonatomic) NSString            *contactName;

/**
 */
@property (strong, nonatomic) NSString            *contactEmail;

/**
 */
@property (strong, nonatomic) NSString            *location;

/**
 */
@property (strong, nonatomic) NSString            *HTMLDescription;

@property (assign) BOOL                             allDay;

/**
 */
@property (strong, nonatomic) NSDate              *startDate;

/**
 */
@property (strong, nonatomic) NSDate              *endDate;

@property (strong, nonatomic) NSString              *tag;

/**
 */
@property (strong, nonatomic) NSAttributedString  *attributedDescription;

@end
