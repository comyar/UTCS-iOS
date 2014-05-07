//
//  UTCSAppDelegate.h
//  UTCS
//
//  Created by Comyar Zaheri on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;
@import QuartzCore;

#import "UTCSMenuViewController.h"
#import <Tweaks/FBTweakShakeWindow.h>


/**
 UTCSAppDelegate
 */
@interface UTCSAppDelegate : UIResponder <UIApplicationDelegate, UTCSMenuViewControllerDelegate>

/**
 Window used by FBTweaks. Allows the tweak window to be presented when the device
 is shaked. Behaves similarly to a UIWindow in production.
 */
@property (nonatomic) FBTweakShakeWindow *window;

@end
