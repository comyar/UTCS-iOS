//
//  UTCSAppDelegate.h
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UTCSMenuViewControllerDelegate.h"

@class  UTCSSideMenuViewController;

/**
 */
@interface UTCSAppDelegate : UIResponder <UIApplicationDelegate, UTCSMenuViewControllerDelegate>

//
@property (strong, nonatomic) UIWindow                      *window;

//
@property (strong, nonatomic) UTCSSideMenuViewController    *sideMenuViewController;

@end
