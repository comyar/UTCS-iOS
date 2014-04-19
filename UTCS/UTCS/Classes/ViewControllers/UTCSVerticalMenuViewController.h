//
//  UTCSVerticalMenuViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 */
extern NSString * const UTCSVerticalMenuDisplayNotification;



/**
 */
@interface UTCSVerticalMenuViewController : UIViewController <UIGestureRecognizerDelegate>

/**
 */
- (instancetype)initWithMenuViewController:(UIViewController *)menuViewController
                     contentViewController:(UIViewController *)contentViewController;

/**
 */
- (void)showMenu;

/**
 */
- (void)hideMenu;

/**
 */
@property (nonatomic) UIViewController  *menuViewController;

/**
 */
@property (nonatomic) UIViewController  *contentViewController;

@end
