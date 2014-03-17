//
//  UTCSNewsStoryManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/16/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ UTCSNewStoryManagerCompletion) (NSArray *newsStories, NSError *error);


extern NSString * const UTCSNewsStoryTitleFontAttribute;
extern NSString * const UTCSNewsStoryTitleFontColorAttribute;

extern NSString * const UTCSNewsStoryDateFontAttribute;
extern NSString * const UTCSNewsStoryDateFontColorAttribute;

extern NSString * const UTCSNewsStoryTextFontAttribute;
extern NSString * const UTCSNewsStoryTextFontColorAttribute;

extern NSString * const UTCSNewsStoryParagraphLineSpacing;


/**
 */
@interface UTCSNewsStoryManager : NSObject

/**
 */
+ (void)newsStoriesWithFontAttributes:(NSDictionary *)attributes completion:(UTCSNewStoryManagerCompletion)completion;

@end
