//
//  UTCSVerticalMenuViewControllerDelegate.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UTCSVerticalMenuViewController;

@protocol UTCSVerticalMenuViewControllerDelegate <NSObject>

@required
- (BOOL)shouldRecognizeVerticalMenuViewControllerPanGesture;

@optional
- (void)verticalMenuViewController:(UTCSVerticalMenuViewController *)verticalMenuViewController
        willShowMenuViewController:(UIViewController *)menuViewController;

- (void)verticalMenuViewController:(UTCSVerticalMenuViewController *)verticalMenuViewController
         didShowMenuViewController:(UIViewController *)menuViewController;

- (void)verticalMenuViewController:(UTCSVerticalMenuViewController *)verticalMenuViewController
        willHideMenuViewController:(UIViewController *)menuViewController;

- (void)verticalMenuViewController:(UTCSVerticalMenuViewController *)verticalMenuViewController
         didHideMenuViewController:(UIViewController *)menuViewController;



@end
