//
//  UTCSSettingsManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSStateManager.h"


static NSString * const hasStarredEventKey  = @"hasStarredEvent";
static NSString * const starredEventsKey     = @"starredEvents";
static NSString * const starredEventNotificationsKey = @"starredEventNotifications";
static NSString * const eventNotificationsKey   = @"eventNotifications";
static NSString * const preferredLabKey    = @"preferredLab";


#pragma mark - UTCSSettingsManager Implementation

@implementation UTCSStateManager

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
        _hasStarredEvent = [[NSUserDefaults standardUserDefaults]boolForKey:hasStarredEventKey];
        _starredEvents = [self loadArrayWithKey:starredEventsKey];
        _starredEventNotifications = [self loadArrayWithKey:starredEventNotificationsKey];
        _eventNotifications = [[NSUserDefaults standardUserDefaults]boolForKey:eventNotificationsKey];
        _preferredLab = [[NSUserDefaults standardUserDefaults]integerForKey:preferredLabKey];
    }
    return self;
}

+ (UTCSStateManager *)sharedManager
{
    static UTCSStateManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UTCSStateManager alloc]_init];
    });
    return sharedManager;
}

#pragma mark Starred Events

- (void)setStarredEvents:(NSArray *)starredEvents
{
    _starredEvents = starredEvents;
    [self saveArray:_starredEvents withKey:starredEventsKey];
}

- (void)setHasStarredEvent:(BOOL)hasStarredEvent
{
    _hasStarredEvent = hasStarredEvent;
    [[NSUserDefaults standardUserDefaults]setBool:_hasStarredEvent forKey:hasStarredEventKey];
}

- (void)setStarredEventNotifications:(NSArray *)starredEventNotifications
{
    _starredEventNotifications = starredEventNotifications;
    [self saveArray:_starredEventNotifications withKey:starredEventNotificationsKey];
}

#pragma mark Settings

- (void)setEventNotifications:(BOOL)eventNotifications
{
    _eventNotifications = eventNotifications;
    [[NSUserDefaults standardUserDefaults]setBool:_eventNotifications forKey:eventNotificationsKey];
}

- (void)setPreferredLab:(NSInteger)preferredLab
{
    _preferredLab = preferredLab;
    [[NSUserDefaults standardUserDefaults]setInteger:_preferredLab forKey:preferredLabKey];
}

#pragma mark Helpers

- (void)saveArray:(NSArray *)array withKey:(NSString *)key
{
    if (array) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        if (data) {
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
        }
    }
}

- (NSArray *)loadArrayWithKey:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (data) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return array;
    }
    return nil;
}

@end
