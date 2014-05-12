//
//  UTCSStarredEventManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSStarredEventManager.h"
#import "UTCSStateManager.h"
#import "UTCSEvent.h"

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

- (NSArray *)allEvents
{
    return [UTCSStateManager sharedManager].starredEvents;
}

- (void)addEvent:(UTCSEvent *)event
{
    if (!event || [self containsEvent:event]) {
        return;
    }
    
    NSMutableArray *starredEvents = [[UTCSStateManager sharedManager].starredEvents mutableCopy];
    if (!starredEvents) {
        starredEvents = [NSMutableArray new];
    }
    [starredEvents addObject:event];
    [UTCSStateManager sharedManager].starredEvents = starredEvents;
    
    // Register notification
}

- (BOOL)containsEvent:(UTCSEvent *)event
{
    for (UTCSEvent *starredEvent in [UTCSStateManager sharedManager].starredEvents) {
        if ([event.eventID isEqualToString:starredEvent.eventID]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeEvent:(UTCSEvent *)event
{
    if (!event || ![self containsEvent:event]) {
        return;
    }
    
    UTCSEvent *removeEvent = nil;
    NSMutableArray *starredEvents = [[UTCSStateManager sharedManager].starredEvents mutableCopy];
    for (UTCSEvent *starredEvent in starredEvents) {
        if ([starredEvent.eventID isEqualToString:event.eventID]) {
            removeEvent = starredEvent;
            break;
        }
    }
    
    if (removeEvent) {
        [starredEvents removeObject:removeEvent];
    }
    
    // unregister notification
    
    [UTCSStateManager sharedManager].starredEvents = starredEvents;
}

- (void)removeAllEvents
{
    [UTCSStateManager sharedManager].starredEvents = [NSArray new];
}

@end
