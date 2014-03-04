//
//  UTCSEvent.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

extern NSString * const UTCSParseEventName;
extern NSString * const UTCSParseEventContactName;
extern NSString * const UTCSParseEventContactEmail;
extern NSString * const UTCSParseEventLocation;
extern NSString * const UTCSParseEventHTMLDescription;
extern NSString * const UTCSParseEventStartDate;
extern NSString * const UTCSParseEventEndDate;


/**
 */
@interface UTCSEvent : NSObject

/**
 */
+ (UTCSEvent *)eventWithParseObject:(PFObject *)object;

/**
 */
- (instancetype)initWithParseObject:(PFObject *)object;

/**
 */
- (void)initializeAttributedDescriptionWithBoldFont:(UIFont *)boldFont font:(UIFont *)font;

/**
 */
@property (strong, nonatomic, readonly) NSString            *name;

/**
 */
@property (strong, nonatomic, readonly) NSString            *contactName;

/**
 */
@property (strong, nonatomic, readonly) NSString            *contactEmail;

/**
 */
@property (strong, nonatomic, readonly) NSString            *location;

/**
 */
@property (strong, nonatomic, readonly) NSString            *HTMLDescription;

/**
 */
@property (strong, nonatomic, readonly) NSDate            *startDate;

/**
 */
@property (strong, nonatomic, readonly) NSDate            *endDate;

/**
 */
@property (strong, nonatomic, readonly) NSAttributedString  *attributedDescription;

@end
