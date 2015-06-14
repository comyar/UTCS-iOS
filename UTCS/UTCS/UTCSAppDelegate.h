//
//  UTCSAppDelegate.h
//  UTCS
//
//  Created by Comyar Zaheri on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import UIKit;
@import QuartzCore;
#import "UTCSMenuViewController.h"



#pragma mark - UTCSAppDelegate Interface

/**
 UTCSAppDelegate is the delegate for the UIApplication singleton and is initialized in the UIApplicationMain function.
 */
@interface UTCSAppDelegate : UIResponder <UIApplicationDelegate, UTCSMenuViewControllerDelegate>

/**
 Window used by FBTweaks. Allows the tweak window to be presented when the device
 is shaked. Behaves similarly to a UIWindow in production. 
 */
@property (nonatomic) UIWindow *window;

@end
