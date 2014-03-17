//
//  UTCSNewsArticle.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 */
extern NSString *const UTCSParseNewsStoryTitle;

/**
 */
extern NSString *const UTCSParseNewsStoryDate;

/**
 */
extern NSString *const UTCSParseNewStoryHTML;


/**
 */
@interface UTCSNewsStory : NSObject

+ (UTCSNewsStory *)newsStoryWithParseObject:(PFObject *)object;

/**
 */
+ (UTCSNewsStory *)newsStoryWithParseObject:(PFObject *)object attributedContent:(NSAttributedString *)attributedContent;


/**
 */
- (instancetype)initWithParseObject:(PFObject *)object;

/**
 */
- (instancetype)initWithParseObject:(PFObject *)object attributedContent:(NSAttributedString *)attributedContent;

// -----
// @name Properties
// -----

//
@property (strong, nonatomic, readonly) NSString                *title;

//
@property (strong, nonatomic, readonly) NSDate                  *date;

//
@property (strong, nonatomic, readonly) NSString                *html;

//
@property (strong, nonatomic)           NSAttributedString      *attributedContent;

@end
