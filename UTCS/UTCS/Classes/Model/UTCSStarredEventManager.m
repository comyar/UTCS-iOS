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
        [self purgePastEvents];
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
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.fireDate = [event.startDate dateByAddingTimeInterval:(-3600)]; // one hour before
    if (event.allDay) {
        notification.fireDate = [event.startDate dateByAddingTimeInterval:28800]; // Make start date 8 am (add 8 hours)
    }
    
    notification.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CDT"];
    notification.alertBody = [NSString stringWithFormat:@"%@ starts in an hour!", event.name];
    notification.alertAction = @"View Event Details";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = @{@"eventID": event.eventID};
    
    NSMutableArray *starredEventNotifications = [[UTCSStateManager sharedManager].starredEventNotifications mutableCopy];
    if (!starredEventNotifications) {
        starredEventNotifications = [NSMutableArray new];
    }
    [starredEventNotifications addObject:notification];
    [UTCSStateManager sharedManager].starredEventNotifications = starredEventNotifications;
    
    [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    
    [UTCSStateManager sharedManager].hasStarredEvent = YES;
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
    
    UILocalNotification *removeNotification = nil;
    NSMutableArray *starredEventNotifications = [[UTCSStateManager sharedManager].starredEventNotifications mutableCopy];
    for (UILocalNotification *notification in starredEventNotifications) {
        if ([notification.userInfo[@"eventID"] isEqualToString:event.eventID]) {
            removeNotification = notification;
            break;
        }
    }
    
    if (removeNotification) {
        [[UIApplication sharedApplication]cancelLocalNotification:removeNotification];
        [starredEventNotifications removeObject:removeNotification];
    }
    
    [UTCSStateManager sharedManager].starredEvents = starredEvents;
    [UTCSStateManager sharedManager].starredEventNotifications = starredEventNotifications;
}

- (void)removeAllEvents
{
    [UTCSStateManager sharedManager].starredEvents = [NSArray new];
    [UTCSStateManager sharedManager].starredEventNotifications = [NSArray new];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}

- (void)purgePastEvents
{
    for (UTCSEvent *event in [self allEvents]) {
        if ([event.endDate timeIntervalSinceDate:[NSDate date]] < - 3600) { // purge after hour past end
            [self removeEvent:event];
        }
    }
}

@end
