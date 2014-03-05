//
//  UTCSNewsArticle.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UTCSParseNewsStoryTitle;
extern NSString *const UTCSParseNewsStoryDate;
extern NSString *const UTCSParseNewsStoryHTMLText;

extern NSString *const UTCSNewsStoryDetailBoldFont;
extern NSString *const UTCSNewsStoryDetailBoldColor;
extern NSString *const UTCSNewsStoryDetailNormalFont;
extern NSString *const UTCSNewsStoryDetailNormalColor;

@interface UTCSNewsStory : NSObject

/**
 */
+ (UTCSNewsStory *)newsStoryWithParseObject:(PFObject *)object;

/**
 */
- (instancetype)initWithParseObject:(PFObject *)object;

/**
 */
- (void)initializeAttributedTextWithAttributes:(NSDictionary *)attributes;

@property (strong, nonatomic, readonly) NSString    *title;

@property (strong, nonatomic, readonly) NSDate      *date;

@property (strong, nonatomic, readonly) NSString    *HTMLText;

@property (strong, nonatomic, readonly) NSAttributedString *attributedText;

@end
