//
//  UTCSOnboardingManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import UIKit;


#pragma mark - UTCSOnboardingManager Interface

/**
 */
@interface UTCSOnboardingManager : NSObject

// -----
// @name Getting the Onboarding Manager
// -----

#pragma mark Getting the Onboarding Manager

/**
 */
+ (UTCSOnboardingManager *)sharedManager;

// -----
// @name Using the Onboarding Manager
// -----

/**
 */
- (void)didStarEvent;

/**
 */
- (void)applicationDidBecomeActive;

@end
