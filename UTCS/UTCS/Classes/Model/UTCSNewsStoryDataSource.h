//
//  UTCSNewsStoryDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UTCSNewsStoryDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) NSArray *newsStories;

- (void)updateNewsStories:(void (^)(void))completion;

@end
