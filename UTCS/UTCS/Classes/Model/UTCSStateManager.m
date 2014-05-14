//
//  UTCSSettingsManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSStateManager.h"


#pragma mark - Constants

// Key to store hasStarredEvent
static NSString * const hasStarredEventKey              = @"hasStarredEvent";

// Key to store starredEvents
static NSString * const starredEventsKey                = @"starredEvents";

// Key to store starredEventNotifications
static NSString * const starredEventNotificationsKey    = @"starredEventNotifications";

// Key to store eventNotifications
static NSString * const eventNotificationsKey           = @"eventNotifications";

// Key to store preferredLab
static NSString * const preferredLabKey                 = @"preferredLab";

// Key to store authenticated
static NSString * const authenticatedKey                = @"authenticated";


#pragma mark - UTCSSettingsManager Implementation

@implementation UTCSStateManager

#pragma mark Getting the UTCSStateManager

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
        _starredEvents              = [self loadArrayWithKey:starredEventsKey];
        _starredEventNotifications  = [self loadArrayWithKey:starredEventNotificationsKey];
        _authenticated              = [[NSUserDefaults standardUserDefaults]boolForKey:authenticatedKey];
        _hasStarredEvent            = [[NSUserDefaults standardUserDefaults]boolForKey:hasStarredEventKey];
        _eventNotifications         = [[NSUserDefaults standardUserDefaults]boolForKey:eventNotificationsKey];
        _preferredLab               = [[NSUserDefaults standardUserDefaults]integerForKey:preferredLabKey];
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

#pragma mark Authentication

- (void)setAuthenticated:(BOOL)authenticated
{
    _authenticated = authenticated;
    [[NSUserDefaults standardUserDefaults]setBool:_authenticated forKey:authenticatedKey];
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

#pragma mark Helper

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
