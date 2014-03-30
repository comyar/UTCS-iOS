//
//  UTCSEventsDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTCSEventsManager : NSObject <UITableViewDataSource>

- (void)updateEventsWithCompletion:(void (^)(void))completion;

@property (nonatomic, readonly) NSArray *events;

@end
