//
//  UTCSNewsStoryDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 UTCSNewsStoryDataSource 
 */
@interface UTCSNewsStoryDataSource : NSObject <UITableViewDataSource>

/**
 Asynchronously updates the news stories
 @param completion Completion handler block to execute when update finishes
 */
- (void)updateNewsStoriesWithCompletion:(void (^)(void))completion;

/**
 Available UTCS news stories, or nil if no available news stories
 
 May be nil if no news stories have been cached and no network connection is available
 */
@property (nonatomic, readonly) NSArray *newsStories;

@end
