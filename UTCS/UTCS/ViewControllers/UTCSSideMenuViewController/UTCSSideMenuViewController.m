//
//  UTCSSideMenuViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSideMenuViewController.h"
#import "UIImage+ImageEffects.h"

#pragma mark - UTCSSideMenuViewController Class Extension

@interface UTCSSideMenuViewController ()

//
@property (assign, nonatomic) BOOL          menuVisible;

//
@property (assign, nonatomic) CGPoint       originalPoint;

//
@property (assign, nonatomic) CGFloat       animationVelocity;

//
@property (strong, nonatomic) UIView        *backgroundImageViewContainer;

//
@property (strong, nonatomic) UIImageView   *backgroundImageView;

//
@property (strong, nonatomic) UIImageView   *blurredBackgroundImageView;

@end


#pragma mark - UTCSSideMenuViewController Implementation

@implementation UTCSSideMenuViewController

#pragma mark Creating a UTCSSideMenuViewController

- (id)init
{
    return [self initWithContentViewController:nil menuViewController:nil];
}

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _contentViewController  = contentViewController;
        _menuViewController     = menuViewController;
        
        _animationDuration = 0.25f;
        _panGestureEnabled = YES;
        _interactivePopGestureRecognizerEnabled = YES;
        
        _scaleContentView = YES;
        _contentViewScaleValue = 0.7f;
        
        _scaleBackgroundImageView = NO;
        
        _parallaxEnabled = YES;
        _parallaxMenuMinimumRelativeValue = @(-25);
        _parallaxMenuMaximumRelativeValue = @(25);
        
        _parallaxContentMinimumRelativeValue = @(-50);
        _parallaxContentMaximumRelativeValue = @(50);
        
        _bouncesHorizontally = YES;
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    if (!_contentViewInLandscapeOffsetCenterX)
        _contentViewInLandscapeOffsetCenterX = CGRectGetHeight(self.view.frame) + 30.f;
    
    if (!_contentViewInPortraitOffsetCenterX)
        _contentViewInPortraitOffsetCenterX  = CGRectGetWidth(self.view.frame) + 30.f;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Initialize background image view container
    self.backgroundImageViewContainer = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.backgroundImageViewContainer];
    
    // Initialize background image view
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.backgroundImageView.image = self.backgroundImage;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.backgroundImageViewContainer addSubview:self.backgroundImageView];
    self.backgroundImageViewContainer.alpha = 0.0;
    
    // Initialize blurred background image view
    self.blurredBackgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.blurredBackgroundImageView.alpha = 0.0;
    self.blurredBackgroundImageView.image = self.blurredBackgroundImage;
    self.blurredBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.backgroundImageViewContainer addSubview:self.blurredBackgroundImageView];
    
    // Configure view controllers
    self.menuViewController.view.alpha = 0.0;
    [self configureDisplayController:self.menuViewController frame:self.view.bounds];
    [self configureDisplayController:self.contentViewController frame:self.view.bounds];
    [self addMenuViewControllerMotionEffects];
    
    // Scale background image view
    if(self.scaleBackgroundImageView) {
        self.backgroundImageViewContainer.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    }
    
    // Add pan gesture recognizer
    if (self.panGestureEnabled) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                              action:@selector(panGestureRecognized:)];
        panGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
}

#pragma mark Configuring Child View Controllers

- (void)configureDisplayController:(UIViewController *)controller frame:(CGRect)frame
{
    controller.view.frame = frame;
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)configureHideController:(UIViewController *)controller
{
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

#pragma mark Using a UTCSSideMenuViewController

- (void)presentMenuViewController
{
    // Prepare background image view for presentation
    if (self.scaleBackgroundImageView) {
        self.backgroundImageViewContainer.transform = CGAffineTransformIdentity;
        self.backgroundImageViewContainer.frame = self.view.bounds;
        self.backgroundImageViewContainer.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    }
    
    self.backgroundImageViewContainer.alpha = 1.0;
    
    // Prepare menu view controller for presentation
    self.menuViewController.view.transform = CGAffineTransformIdentity;
    self.menuViewController.view.frame = self.view.bounds;
    self.menuViewController.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    self.menuViewController.view.alpha = 0.0;
    
    // Delegate callback
    if ([self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideMenuViewController:willShowMenuViewController:)]) {
        [self.delegate sideMenuViewController:self willShowMenuViewController:self.menuViewController];
    }
    
    [self showMenuViewController];
}

- (void)showMenuViewController
{
    [self showMenuViewControllerWithVelocity:self.animationVelocity];
}

- (void)showMenuViewControllerWithVelocity:(CGFloat)velocity
{
    // Ensure subviews resign first responder
    [self.view.window endEditing:YES];
    
    // Ignore touch events during animation
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    
    CGFloat deltaOffset = (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.contentViewInLandscapeOffsetCenterX : self.contentViewInPortraitOffsetCenterX) - self.menuViewController.view.frame.origin.x;
    CGFloat duration = MIN(self.animationDuration, fabs(deltaOffset / velocity));
    [UIView animateWithDuration:duration animations: ^ {
        
        // Scale content view
        if (self.scaleContentView) {
            self.contentViewController.view.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        }
        
        // Set content view's center based on device orientation
        self.contentViewController.view.center = CGPointMake((UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.contentViewInLandscapeOffsetCenterX : self.contentViewInPortraitOffsetCenterX), self.contentViewController.view.center.y);
        
        // Configure menu view controller
        self.menuViewController.view.alpha = 1.0f;
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        
        // Scale the background image view
        if (self.scaleBackgroundImageView) {
            self.backgroundImageViewContainer.transform = CGAffineTransformIdentity;
        }
        
        self.blurredBackgroundImageView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        // Restore touch events
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        
        // Add motion effects to content view controller
        [self addContentViewControllerMotionEffects];
        
        // Delegate callback
        if ([self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideMenuViewController:didShowMenuViewController:)]) {
            [self.delegate sideMenuViewController:self didShowMenuViewController:self.menuViewController];
        }
        self.contentViewController.view.userInteractionEnabled = NO;
        self.contentViewController.navigationController.navigationBar.userInteractionEnabled = YES;
        self.menuVisible = YES;
        
        // Update the status bar style
        [self updateStatusBar];
    }];
}

- (void)hideMenuViewController
{
    [self hideMenuViewControllerWithVelocity:self.animationVelocity];
}

- (void)hideMenuViewControllerWithVelocity:(CGFloat)velocity
{
    // Delegate callback
    if ([self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideMenuViewController:willHideMenuViewController:)]) {
        [self.delegate sideMenuViewController:self willHideMenuViewController:self.menuViewController];
    }
    
    // Ignore touch events during animation
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    
    CGFloat deltaOffset = (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.contentViewInLandscapeOffsetCenterX : self.contentViewInPortraitOffsetCenterX) - self.menuViewController.view.frame.origin.x;
    CGFloat duration = MIN(self.animationDuration, fabs(deltaOffset / velocity));
    [UIView animateWithDuration:duration animations:^{
        
        // Restore the content view's transform and frame
        self.contentViewController.view.transform = CGAffineTransformIdentity;
        self.contentViewController.view.frame = self.view.bounds;
        
        // Restore the menu view's hidden state
        self.menuViewController.view.alpha = 0.0;
        self.menuViewController.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        
        // Scale background image view
        if (self.scaleBackgroundImageView) {
            self.backgroundImageViewContainer.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
        }
        
        self.blurredBackgroundImageView.alpha = 0.0;
        
        // Remove any motion effects on the content view controller
        if (self.parallaxEnabled) {
            for (UIMotionEffect *effect in self.contentViewController.view.motionEffects) {
                [self.contentViewController.view removeMotionEffect:effect];
            }
        }
        
    } completion:^(BOOL finished) {
        
        // Restore touch events
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        
        // Delegate callback
        if ([self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] &&
            [self.delegate respondsToSelector:@selector(sideMenuViewController:didHideMenuViewController:)]) {
            [self.delegate sideMenuViewController:self didHideMenuViewController:self.menuViewController];
        }
        
        self.menuVisible = NO;
        self.contentViewController.view.userInteractionEnabled = YES;
        
        // Fade out the background image so it's not visible around the content view's rounded edges
        [UIView animateWithDuration:1.0 animations: ^ {
            self.backgroundImageViewContainer.alpha = 0.0;
        }];
        
        // Update the status bar style
        [self updateStatusBar];
    }];
}

#pragma mark Adding Motion Effects

- (void)addMenuViewControllerMotionEffects
{
    if (self.parallaxEnabled) {
        for (UIMotionEffect *effect in self.menuViewController.view.motionEffects) {
            [self.menuViewController.view removeMotionEffect:effect];
        }
        UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        interpolationHorizontal.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue;
        interpolationHorizontal.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue;
        
        UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        interpolationVertical.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue;
        interpolationVertical.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue;
           
        [self.menuViewController.view addMotionEffect:interpolationHorizontal];
        [self.menuViewController.view addMotionEffect:interpolationVertical];
    }
}

- (void)addContentViewControllerMotionEffects
{
    if (self.parallaxEnabled) {
        for (UIMotionEffect *effect in self.contentViewController.view.motionEffects) {
            [self.contentViewController.view removeMotionEffect:effect];
        }
        UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue;
        interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue;

        UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        interpolationVertical.minimumRelativeValue = self.parallaxContentMinimumRelativeValue;
        interpolationVertical.maximumRelativeValue = self.parallaxContentMaximumRelativeValue;

        [self.contentViewController.view addMotionEffect:interpolationHorizontal];
        [self.contentViewController.view addMotionEffect:interpolationVertical];
    }
}

#pragma mark Gesture Recognizer Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.interactivePopGestureRecognizerEnabled && [self.contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.contentViewController;
        if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer.enabled) {
            return NO;
        }
    }
  
    if (self.panFromEdge && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !self.menuVisible) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.x < 30) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if ([self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideMenuViewController:didRecognizePanGesture:)])
        [self.delegate sideMenuViewController:self didRecognizePanGesture:recognizer];
    
    if (!self.panGestureEnabled) {
        return;
    }
    
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if (!self.menuVisible && [self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideMenuViewController:willShowMenuViewController:)]) {
            [self.delegate sideMenuViewController:self willShowMenuViewController:self.menuViewController];
        }
        
        self.originalPoint = CGPointMake(self.contentViewController.view.center.x - CGRectGetWidth(self.contentViewController.view.bounds) / 2.0,self.contentViewController.view.center.y - CGRectGetHeight(self.contentViewController.view.bounds) / 2.0);
        
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        self.menuViewController.view.frame = self.view.bounds;
        
        if (self.scaleBackgroundImageView) {
            self.backgroundImageViewContainer.transform = CGAffineTransformIdentity;
            self.backgroundImageViewContainer.frame = self.view.bounds;
        }
        
        self.backgroundImageViewContainer.alpha = 1.0;
        
        [self.view.window endEditing:YES];
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat delta = self.menuVisible ? (point.x + self.originalPoint.x) / self.originalPoint.x : point.x / self.view.frame.size.width;
        
        CGFloat contentViewScale = self.scaleContentView ? 1 - ((1 - self.contentViewScaleValue) * delta) : 1;
        CGFloat backgroundViewScale = 1.7f - (0.7f * delta);
        CGFloat menuViewScale = 1.5f - (0.5f * delta);
        
        if (!_bouncesHorizontally) {
            contentViewScale = MAX(contentViewScale, self.contentViewScaleValue);
            backgroundViewScale = MAX(backgroundViewScale, 1.0);
            menuViewScale = MAX(menuViewScale, 1.0);
        }
        
        self.menuViewController.view.alpha = delta;
        self.menuViewController.view.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale);
        
        if (self.scaleBackgroundImageView) {
            self.backgroundImageViewContainer.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);
            if (backgroundViewScale < 1.0) {
                self.backgroundImageViewContainer.transform = CGAffineTransformIdentity;
            }
        }
        self.blurredBackgroundImageView.alpha = delta;
        
        NSLog(@"%f", contentViewScale);
        if (contentViewScale > 1.0) {
            if (!self.menuVisible) {
                self.contentViewController.view.transform = CGAffineTransformIdentity;
            }
            self.contentViewController.view.frame = self.view.bounds;
        } else {
            if (!_bouncesHorizontally && self.menuVisible) {
                point.x = MIN(0.0, point.x);
                [recognizer setTranslation:point inView:self.view];
            }
            
            self.contentViewController.view.transform = CGAffineTransformMakeScale(contentViewScale, contentViewScale);
            self.contentViewController.view.transform = CGAffineTransformTranslate(self.contentViewController.view.transform, point.x, 0);
        }
        
        [self updateStatusBar];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.contentViewController.view.frame.origin.x < -512) {
            // ee here
        } else {
            CGPoint velocity = [recognizer velocityInView:self.view];
            if (velocity.x > 0) {
                [self showMenuViewControllerWithVelocity:velocity.x];
            } else {
                [self hideMenuViewControllerWithVelocity:velocity.x];
            }
        }
    }
}

#pragma mark Overridden Setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = [backgroundImage applyDarkEffect];
    if (self.backgroundImageView) {
        self.backgroundImageView.image = _backgroundImage;
    }
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if (!_contentViewController) {
        _contentViewController = contentViewController;
        return;
    }
    CGRect frame = _contentViewController.view.frame;
    CGAffineTransform transform = _contentViewController.view.transform;
    [self configureHideController:_contentViewController];
    _contentViewController = contentViewController;
    [self configureDisplayController:contentViewController frame:self.view.bounds];
    contentViewController.view.transform = transform;
    contentViewController.view.frame = frame;
    
    if(self.menuVisible) {
        [self addContentViewControllerMotionEffects];
    }
}

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated
{
    if (!animated) {
        [self setContentViewController:contentViewController];
    } else {
        contentViewController.view.alpha = 0.0;
        contentViewController.view.frame = self.contentViewController.view.bounds;
        [self.contentViewController.view addSubview:contentViewController.view];
        [UIView animateWithDuration:self.animationDuration animations:^{
            contentViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [contentViewController.view removeFromSuperview];
            [self setContentViewController:contentViewController];
        }];
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController
{
    if (!_menuViewController) {
        _menuViewController = menuViewController;
        return;
    }
    [self configureHideController:_menuViewController];
    _menuViewController = menuViewController;
    [self configureDisplayController:menuViewController frame:self.view.frame];
    
    [self addMenuViewControllerMotionEffects];
    [self.view bringSubviewToFront:self.contentViewController.view];
}

#pragma mark Orientation Handling

- (BOOL)shouldAutorotate
{
    return self.contentViewController.shouldAutorotate;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.menuVisible) {
        self.contentViewController.view.transform = CGAffineTransformIdentity;
        self.contentViewController.view.frame = self.view.bounds;
        self.contentViewController.view.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        self.contentViewController.view.center = CGPointMake((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? self.contentViewInLandscapeOffsetCenterX : self.contentViewInPortraitOffsetCenterX), self.contentViewController.view.center.y);
        CGFloat offset = (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? self.contentViewInLandscapeOffsetCenterX : self.contentViewInPortraitOffsetCenterX);
        self.animationVelocity = offset / self.animationDuration;
    }
}

#pragma mark Status Bar Appearance

- (void)updateStatusBar
{
    [UIView animateWithDuration:0.3f animations: ^ {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIStatusBarStyle statusBarStyle = UIStatusBarStyleDefault;
    statusBarStyle = self.menuVisible ? self.menuViewController.preferredStatusBarStyle : self.contentViewController.preferredStatusBarStyle;
    if (self.contentViewController.view.frame.origin.x > 10) {
        statusBarStyle = self.menuViewController.preferredStatusBarStyle;
    } else {
        statusBarStyle = self.contentViewController.preferredStatusBarStyle;
    }
    return statusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    BOOL statusBarHidden = NO;
    statusBarHidden = self.menuVisible ? self.menuViewController.prefersStatusBarHidden : self.contentViewController.prefersStatusBarHidden;
    if(self.contentViewController.view.frame.origin.x > 10) {
        statusBarHidden = self.menuViewController.prefersStatusBarHidden;
    } else {
        statusBarHidden = self.contentViewController.prefersStatusBarHidden;
    }
    return statusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    UIStatusBarAnimation statusBarAnimation = UIStatusBarAnimationNone;
    statusBarAnimation = self.menuVisible ? self.menuViewController.preferredStatusBarUpdateAnimation : self.contentViewController.preferredStatusBarUpdateAnimation;
    if (self.contentViewController.view.frame.origin.x > 10) {
        statusBarAnimation = self.menuViewController.preferredStatusBarUpdateAnimation;
    } else {
        statusBarAnimation = self.contentViewController.preferredStatusBarUpdateAnimation;
    }
    return statusBarAnimation;
}

@end
