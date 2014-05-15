//
//  UTCSStarredEventManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSEvent.h"
#import "UTCSStateManager.h"
#import "UTCSStarredEventsManager.h"


#pragma mark - UTCSStarredEventsManager Implementation

@implementation UTCSStarredEventsManager

#pragma mark Getting the Starred Events Manager

- (instancetype)init
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform selector %@ of singleton", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

- (instancetype)_init
{
    if (self = [super init]) {
        [self purgePastEvents];
    }
    return self;
}

+ (UTCSStarredEventsManager *)sharedManager
{
    static UTCSStarredEventsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UTCSStarredEventsManager alloc]_init];
    });
    return sharedManager;
}

#pragma mark Using the Starred Events Manager

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
    
    if ([UTCSStateManager sharedManager].eventNotifications) {
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    }
    
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
        if ([event.endDate timeIntervalSinceDate:[NSDate date]] < -3600.0) { // purge after hour past end date
            [self removeEvent:event];
        }
    }
}

#pragma mark Using Notifications

- (void)disableNotifications
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}

- (void)enableNotifications
{
    for (UILocalNotification *notification in [UTCSStateManager sharedManager].starredEventNotifications) {
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    }
}

@end
