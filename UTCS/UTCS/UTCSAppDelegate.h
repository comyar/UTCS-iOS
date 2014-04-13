//
//  UTCSAppDelegate.h
//  UTCS
//
//  Created by Comyar Zaheri on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UTCSMenuViewControllerDelegate.h"
#import "UTCSWebViewController.h"

/**
 */
@interface UTCSAppDelegate : UIResponder <UIApplicationDelegate, UTCSMenuViewControllerDelegate, UTCSWebViewControllerDelegate>

//
@property (nonatomic) UIWindow *window;

@end
