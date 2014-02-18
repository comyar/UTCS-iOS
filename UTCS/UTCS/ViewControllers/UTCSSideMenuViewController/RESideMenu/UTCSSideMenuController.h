//
//  UTCSSideMenuViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UTCSSideMenuViewControllerDelegate;

@interface UTCSSideMenuController : UIViewController <UIGestureRecognizerDelegate>

@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (strong, readwrite, nonatomic) UIImage *backgroundImage;
@property (assign, readwrite, nonatomic) BOOL panGestureEnabled;
@property (assign, readwrite, nonatomic) BOOL panFromEdge;
@property (assign, readwrite, nonatomic) BOOL interactivePopGestureRecognizerEnabled;
@property (assign, readwrite, nonatomic) BOOL scaleContentView;
@property (assign, readwrite, nonatomic) BOOL scaleBackgroundImageView;
@property (assign, readwrite, nonatomic) CGFloat contentViewScaleValue;
@property (assign, readwrite, nonatomic) CGFloat contentViewInLandscapeOffsetCenterX;
@property (assign, readwrite, nonatomic) CGFloat contentViewInPortraitOffsetCenterX;
@property (strong, readwrite, nonatomic) id parallaxMenuMinimumRelativeValue;
@property (strong, readwrite, nonatomic) id parallaxMenuMaximumRelativeValue;
@property (strong, readwrite, nonatomic) id parallaxContentMinimumRelativeValue;
@property (strong, readwrite, nonatomic) id parallaxContentMaximumRelativeValue;
@property (assign, readwrite, nonatomic) BOOL parallaxEnabled;
@property (assign, readwrite, nonatomic) BOOL bouncesHorizontally;

@property (strong, readwrite, nonatomic) UIViewController *contentViewController;
@property (strong, readwrite, nonatomic) UIViewController *menuViewController;

@property (weak, readwrite, nonatomic) id<UTCSSideMenuViewControllerDelegate> delegate;

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController;
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;
- (void)presentMenuViewController;
- (void)hideMenuViewController;

@end

@protocol UTCSSideMenuViewControllerDelegate <NSObject>

@optional
- (void)sideMenuViewController:(UTCSSideMenuController *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)sideMenuViewController:(UTCSSideMenuController *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenuViewController:(UTCSSideMenuController *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenuViewController:(UTCSSideMenuController *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenuViewController:(UTCSSideMenuController *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController;

@end