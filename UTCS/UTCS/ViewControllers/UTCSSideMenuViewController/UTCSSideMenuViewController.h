//
//  UTCSSideMenuViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UTCSSideMenuViewControllerDelegate;

/**
 */
@interface UTCSSideMenuViewController : UIViewController <UIGestureRecognizerDelegate>

//
// @name Creating a UTCSSideMenuViewController
//

/**
 */
- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController;

/**
 */
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

/**
 */
- (void)presentMenuViewController;

/**
 */
- (void)hideMenuViewController;

//
@property (strong, nonatomic) UIViewController *contentViewController;

//
@property (strong, nonatomic) UIViewController *menuViewController;

//
@property (weak, nonatomic)     id<UTCSSideMenuViewControllerDelegate> delegate;

//
@property (assign, nonatomic) UIImage *backgroundImage;

//
@property (assign, nonatomic) NSTimeInterval animationDuration;

//
@property (assign, nonatomic) BOOL scaleContentView;

//
@property (assign, nonatomic) BOOL scaleBackgroundImageView;

//
@property (assign, nonatomic) BOOL panFromEdge;

//
@property (assign, nonatomic) BOOL panGestureEnabled;

//
@property (assign, nonatomic) BOOL interactivePopGestureRecognizerEnabled;

//
@property (assign, nonatomic) CGFloat contentViewScaleValue;

//
@property (assign, nonatomic) CGFloat contentViewInLandscapeOffsetCenterX;

//
@property (assign, nonatomic) CGFloat contentViewInPortraitOffsetCenterX;

//
@property (strong, nonatomic) id parallaxMenuMinimumRelativeValue;

//
@property (strong, nonatomic) id parallaxMenuMaximumRelativeValue;

//
@property (strong, nonatomic) id parallaxContentMinimumRelativeValue;

//
@property (strong, nonatomic) id parallaxContentMaximumRelativeValue;

//
@property (assign, nonatomic) BOOL parallaxEnabled;

//
@property (assign, nonatomic) BOOL bouncesHorizontally;

@end

@protocol UTCSSideMenuViewControllerDelegate <NSObject>

@optional
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenuViewController:(UTCSSideMenuViewController *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController;

@end