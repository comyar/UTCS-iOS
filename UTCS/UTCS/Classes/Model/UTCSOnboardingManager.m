//
//  UTCSOnboardingManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSStateManager.h"
#import "UTCSOnboardingManager.h"
#import "UTCSNavigationController.h"
#import "UTCSWelcomeViewController.h"
#import "UTCSVerticalMenuViewController.h"
#import "UIImage+Cacheless.h"

#pragma mark - UTCSOnboardingManager Implementation

@implementation UTCSOnboardingManager

#pragma mark Getting the Onboarding Manager

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
        
    }
    return self;
}

+ (UTCSOnboardingManager *)sharedManager
{
    static UTCSOnboardingManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UTCSOnboardingManager alloc]_init];
    });
    return sharedManager;
}

#pragma mark Using the Onboarding Manager

- (void)didStarEvent
{
    if (![UTCSStateManager sharedManager].hasStarredEvent) {
        [[[UIAlertView alloc]initWithTitle:@"First Starred Event!"
                                   message:@"You can be notified of starred events an hour before they start! Check your settings."
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil]show];
    }
}

- (void)applicationDidBecomeActive
{
    if (![UTCSStateManager sharedManager].hasCompleteOnboarding) {
        UTCSNavigationController *onboardingNavigationController = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSWelcomeViewController new]];
        onboardingNavigationController.backgroundImageView.image = [UIImage cacheless_imageNamed:@"welcomeBackground"];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:onboardingNavigationController animated:NO completion:nil];
    }
    
}


@end
