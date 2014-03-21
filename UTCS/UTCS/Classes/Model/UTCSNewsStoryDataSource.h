//
//  UTCSNewsStoryDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const UTCSNewsStoryTitleFontAttribute;
extern NSString * const UTCSNewsStoryTitleFontColorAttribute;

extern NSString * const UTCSNewsStoryDateFontAttribute;
extern NSString * const UTCSNewsStoryDateFontColorAttribute;

extern NSString * const UTCSNewsStoryTextFontAttribute;
extern NSString * const UTCSNewsStoryTextFontColorAttribute;

extern NSString * const UTCSNewsStoryParagraphLineSpacing;


@interface UTCSNewsStoryDataSource : NSObject <UITableViewDataSource>

- (void)updateNewsStories:(void (^)(void))completion;

@end
