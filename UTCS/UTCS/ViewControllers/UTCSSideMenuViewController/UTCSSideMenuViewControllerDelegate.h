//
//  UTCSSideMenuViewControllerDelegate.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

@class UTCSSideMenuViewController;

/**
 */
@protocol UTCSSideMenuViewControllerDelegate <NSObject>

@optional

/**
 */
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;

/**
 */
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController;

/**
 */
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController;

/**
 */
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController;

/**
 */
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController;

@end
