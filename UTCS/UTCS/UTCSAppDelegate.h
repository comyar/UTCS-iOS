//
//  UTCSAppDelegate.h
//  UTCS
//
//  Created by Comyar Zaheri on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;
@import QuartzCore;

#import <Tweaks/FBTweakShakeWindow.h>
#import <Tweaks/FBTweakInline.h>

#import "MBProgressHUD.h"
#import "UTCSMenuViewController.h"


/**
 UTCSAppDelegate is the delegate for the UIApplication singleton and is initialized in the UIApplicationMain function.
 */
@interface UTCSAppDelegate : UIResponder <UIApplicationDelegate, UTCSMenuViewControllerDelegate>

/**
 Window used by FBTweaks. Allows the tweak window to be presented when the device
 is shaked. Behaves similarly to a UIWindow in production.
 */
#if DEBUG
@property (nonatomic) FBTweakShakeWindow *window;
#else
/**
 Window to use for release builds. Defining a separate property isn't strictly required, but
 may serve as a good reminder to change the build scheme before releasing to the App Store.
 */
@property (nonatomic) UIWindow *window;
#endif

@end
