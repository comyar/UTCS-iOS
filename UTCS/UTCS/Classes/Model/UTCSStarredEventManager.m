//
//  UTCSStarredEventManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSStarredEventManager.h"
#import "UTCSStateManager.h"


@implementation UTCSStarredEventManager

+ (UTCSStarredEventManager *)sharedManager
{
    static UTCSStarredEventManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UTCSStarredEventManager alloc]_init];
    });
    return sharedManager;
}

- (instancetype)_init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)init
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform selector %@ of singleton", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

#pragma mark Using Starred Event Manager

- (NSArray *)allEventIDs
{
    return [UTCSStateManager sharedManager].starredEventIDs;
}

- (void)addEventID:(NSString *)eventID
{
    if (!eventID) {
        return;
    }
    
    if (![[UTCSStateManager sharedManager].starredEventIDs containsObject:eventID]) {
        NSMutableArray *eventIDs = [[UTCSStateManager sharedManager].starredEventIDs mutableCopy];
        [eventIDs addObject:eventID];
        [[UTCSStateManager sharedManager]setStarredEventIDs:eventIDs];
    }
}

- (BOOL)containsEventID:(NSString *)eventID
{
    return [[UTCSStateManager sharedManager].starredEventIDs containsObject:eventID];
}

- (void)removeEventID:(NSString *)eventID
{
    if (!eventID) {
        return;
    }
    
    if ([[UTCSStateManager sharedManager].starredEventIDs containsObject:eventID]) {
        NSMutableArray *eventIDs = [[UTCSStateManager sharedManager].starredEventIDs mutableCopy];
        [eventIDs removeObject:eventID];
        [[UTCSStateManager sharedManager]setStarredEventIDs:eventIDs];
    }
}

- (void)removeAllEventIDs
{
    [[UTCSStateManager sharedManager]setStarredEventIDs:[NSArray new]];
}

@end
