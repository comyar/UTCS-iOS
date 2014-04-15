//
//  UTCSEventsDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTCSEventsDataSource : NSObject <UITableViewDataSource>

- (void)updateEventsWithCompletion:(void (^)(void))completion;
- (void)filterEventsWithTag:(NSString *)tag;

@property (nonatomic, readonly) NSArray *filteredEvents;

@end
