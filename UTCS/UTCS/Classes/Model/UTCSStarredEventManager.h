//
//  UTCSStarredEventManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import Foundation;


#pragma mark - Forward Declarations

@class UTCSEvent;


#pragma mark - UTCSStarredEventManager Implementation

/**
 */
@interface UTCSStarredEventManager : NSObject

// -----
// @name Getting the Starred Event Manager
// -----

#pragma mark Getting a Starred Event Manager

/**
 */
+ (UTCSStarredEventManager *)sharedManager;

// -----
// @name Using the Starred Event Manager
// -----

/**
 Gets all starred events added to the manager.
 @return All starred events.
 */
- (NSArray *)allEvents;

/**
 Determines whether an event has been added to the manager.
 @param event Event to check.
 @return YES if the event has been added to the manager.
 */
- (BOOL)containsEvent:(UTCSEvent *)event;

/**
 Adds an event to the manager.
 @param event   Event to add.
 */
- (void)addEvent:(UTCSEvent *)event;

/**
 Removes a starred event from the manager.
 @param event   Event to remove.
 */
- (void)removeEvent:(UTCSEvent *)event;

/**
 Removes all events from the manager.
 */
- (void)removeAllEvents;

/**
 Removes all expired events.
 
 The conditions for an 'expired' event are determined by the manager. This method
 should be called occassionally by the app to purge older events.
 */
- (void)purgePastEvents;

// -----
// @name Using Notifications
// -----

/**
 */
- (void)enableNotifications;

/**
 Enables notifications for all starred events.
 */
- (void)disableNotifications;

@end
