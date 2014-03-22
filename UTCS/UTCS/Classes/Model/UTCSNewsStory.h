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
- (instancetype)initWithParseObject:(PFObject *)object;


// -----
// @name Properties
// -----

@property (nonatomic) UIImage                   *headerImage;

//
@property (nonatomic) NSString                  *title;

//
@property (nonatomic) NSString                  *text;

//
@property (nonatomic) NSDate                    *date;

//
@property (nonatomic) NSString                   *json;

//
@property (nonatomic) NSAttributedString        *attributedContent;

@end
