//
//  UTCSSettingsManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import Foundation;


#pragma mark - UTCSStateManager Interface

/**
 UTCSStateManager is a singleton class that manages the persistance of information not directly
 associated with an instance of UTCSDataSource. This includes, for example, app settings. Other 
 managers may also rely on the state manager to persist data. For example, both the 
 UTCSAuthenticationManager as well as the UTCSStarredEventsManager make heavy use of the state
 manager.
 
 Setting the value of any of the state manager's properties will update the corresponding property's value on disk.
 */
@interface UTCSStateManager : NSObject

// -----
// @name Getting a State Manager
// -----

#pragma mark Getting a State Manager

/**
 Returns the shared state manager instance.
 @return The shared state manager instance.
 */
+ (UTCSStateManager *)sharedManager;

// -----
// @name Properties
// -----

/**
 YES if the user is authenticated.
 
 Used by the UTCSAuthenticationManager.
 */
@property (nonatomic) BOOL      authenticated;

/**
 YES if the user has previously starred an event.
 
 Used for on-boarding.
 */
@property (nonatomic) BOOL      hasStarredEvent;

/**
 YES if the user has completed the initial app onboarding
 */
@property (nonatomic) BOOL      hasCompleteOnboarding;

/**
 YES if event notifications are enabled.
 
 Used by settings.
 */
@property (nonatomic) BOOL      eventNotifications;

/**
 Preferred lab number.
 
 Used by settings.
 */
@property (nonatomic) NSInteger preferredLab;

/**
 Events starred by the user.
 
 Used by the UTCSStarredEventsManager.
 */
@property (nonatomic) NSArray   *starredEvents;

/**
 Notifications for starred events.
 
 Used by the UTCSStarredEventsManager.
 */
@property (nonatomic) NSArray   *starredEventNotifications;

@end
