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
@property (assign, nonatomic) BOOL              menuVisible;

//
@property (assign, nonatomic) CGPoint           originalPoint;

//
@property (assign, nonatomic) CGFloat           animationVelocity;

//
@property (strong, nonatomic) UIImageView       *backgroundImageView;

//
@property (strong, nonatomic) NSMutableArray    *blurredBackgroundImages;

//
@property (assign, nonatomic) NSInteger         blurredImageIndex;

//
@property (assign, nonatomic)   CGFloat         contentViewScaleValue;

//
@property (strong, nonatomic) UIBarButtonItem   *menuBarButtonItem;

//
@property (assign, nonatomic)   CGFloat         contentViewInLandscapeOffsetCenterX;

//
@property (assign, nonatomic)   CGFloat         contentViewInPortraitOffsetCenterX;

//
@property (strong, nonatomic)   NSNumber        *parallaxMenuMinimumRelativeValue;

//
@property (strong, nonatomic)   NSNumber        *parallaxMenuMaximumRelativeValue;

//
@property (strong, nonatomic)   NSNumber        *parallaxContentMinimumRelativeValue;

//
@property (strong, nonatomic)   NSNumber        *parallaxContentMaximumRelativeValue;

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
        
        _contentViewScaleValue = 0.7f;
        
        _scaleBackgroundImageView = YES;
        
        _parallaxMenuMinimumRelativeValue = @(-15);
        _parallaxMenuMaximumRelativeValue = @(15);
        
        _parallaxContentMinimumRelativeValue = @(-25);
        _parallaxContentMaximumRelativeValue = @(25);
        
        _blurredBackgroundImages = [NSMutableArray new];
        _blurredImageIndex = 0;
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.contentViewInLandscapeOffsetCenterX = CGRectGetHeight(self.view.frame) + 30.f;
    self.contentViewInPortraitOffsetCenterX  = CGRectGetWidth(self.view.frame) + 30.f;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Initialize background image view
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.backgroundImageView.image = self.backgroundImage;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.backgroundImageView];
    
    // Configure view controllers
    self.menuViewController.view.alpha = 0.0;
    [self configureDisplayController:self.menuViewController frame:self.view.bounds];
    [self configureDisplayController:self.contentViewController frame:self.view.bounds];
    [self addMenuViewControllerMotionEffects];
    
    // Initialize menu bar button item
    self.menuBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(didTouchUpInsideBarButtonItem:)];
    if([self.contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.contentViewController;
        navigationController.navigationBar.topItem.leftBarButtonItem = self.menuBarButtonItem;
    }
    
    // Scale background image view
    if(self.scaleBackgroundImageView) {
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    }
    
    // Add pan gesture recognizer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                          action:@selector(panGestureRecognized:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
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
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        self.backgroundImageView.frame = self.view.bounds;
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    }
    
    self.backgroundImageView.alpha = 1.0;
    
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
        self.contentViewController.view.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        
        // Set content view's center based on device orientation
        self.contentViewController.view.center = CGPointMake((UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.contentViewInLandscapeOffsetCenterX : self.contentViewInPortraitOffsetCenterX), self.contentViewController.view.center.y);
        
        // Configure menu view controller
        self.menuViewController.view.alpha = 1.0f;
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        
        // Scale the background image view
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView.transform = CGAffineTransformIdentity;
        }
        
        [self blurBackgroundImageWithFrameDuration:duration / ([self.blurredBackgroundImages count] - self.blurredImageIndex)];
        
    } completion:^(BOOL finished) {
        
        // Restore touch events
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        
        // Add motion effects to content view controller
        [self addContentViewControllerMotionEffects];
        
        // Delegate callback
        if ([self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideMenuViewController:didShowMenuViewController:)]) {
            [self.delegate sideMenuViewController:self didShowMenuViewController:self.menuViewController];
        }
        
        for(UIViewController *viewController in self.contentViewController.childViewControllers) {
            viewController.view.userInteractionEnabled = NO;
        }
        
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
    
    // Remove any motion effects on the content view controller
    for (UIMotionEffect *effect in self.contentViewController.view.motionEffects) {
        [self.contentViewController.view removeMotionEffect:effect];
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
            self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
        }
        
        [self unblurBackgroundImageWithFrameDuration:duration / self.blurredImageIndex];
        
    } completion:^(BOOL finished) {
        
        // Restore touch events
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        
        // Delegate callback
        if ([self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] &&
            [self.delegate respondsToSelector:@selector(sideMenuViewController:didHideMenuViewController:)]) {
            [self.delegate sideMenuViewController:self didHideMenuViewController:self.menuViewController];
        }
        
        // Remove any motion effects on the content view controller
        for (UIMotionEffect *effect in self.contentViewController.view.motionEffects) {
            [self.contentViewController.view removeMotionEffect:effect];
        }
        
        self.menuVisible = NO;
        for(UIViewController *viewController in self.contentViewController.childViewControllers) {
            viewController.view.userInteractionEnabled = YES;
        }
        
        // Fade out the background image so it's not visible around the content view's rounded edges
        [UIView animateWithDuration:0.3 animations: ^ {
            self.backgroundImageView.alpha = 0.0;
        }];
        
        // Update the status bar style
        [self updateStatusBar];
    }];
}

- (void)blurBackgroundImageWithFrameDuration:(CGFloat)frameDuration
{
    if(self.blurredImageIndex < [self.blurredBackgroundImages count] - 1) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(frameDuration * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.backgroundImageView.image = self.blurredBackgroundImages[self.blurredImageIndex];
            self.blurredImageIndex++;
            [self blurBackgroundImageWithFrameDuration:frameDuration];
        });
    }
}

- (void)unblurBackgroundImageWithFrameDuration:(CGFloat)frameDuration
{
    if(self.blurredImageIndex > 0) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(frameDuration * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.backgroundImageView.image = self.blurredBackgroundImages[MIN(self.blurredImageIndex, [self.blurredBackgroundImages count] - 1)];
            self.blurredImageIndex--;
            [self blurBackgroundImageWithFrameDuration:frameDuration];
        });
    }
}

#pragma mark Adding Motion Effects

- (void)addMenuViewControllerMotionEffects
{
    // Remove motion effects before trying to add any more
    for (UIMotionEffect *effect in self.menuViewController.view.motionEffects) {
        [self.menuViewController.view removeMotionEffect:effect];
    }
        
    // Initialize horizontal interpolation effect
    UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    interpolationHorizontal.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue;
    interpolationHorizontal.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue;
        
    // Initialize vertical interpolation effect
    UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    interpolationVertical.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue;
    interpolationVertical.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue;
        
    // Add effects
    [self.menuViewController.view addMotionEffect:interpolationHorizontal];
    [self.menuViewController.view addMotionEffect:interpolationVertical];
}

- (void)addContentViewControllerMotionEffects
{
    // Remove motion effects before trying to add any more
    for (UIMotionEffect *effect in self.contentViewController.view.motionEffects) {
        [self.contentViewController.view removeMotionEffect:effect];
    }
        
    // Initialize horizontal interpolation effect
    UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue;
    interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue;
        
    // Initialize vertical interpolation effect
    UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    interpolationVertical.minimumRelativeValue = self.parallaxContentMinimumRelativeValue;
    interpolationVertical.maximumRelativeValue = self.parallaxContentMaximumRelativeValue;

    // Add effects
    [self.contentViewController.view addMotionEffect:interpolationHorizontal];
    [self.contentViewController.view addMotionEffect:interpolationVertical];
}

#pragma mark Bar Button Item Methods

- (void)didTouchUpInsideBarButtonItem:(UIBarButtonItem *)item
{
    if(self.menuVisible) {
        [self hideMenuViewController];
    } else {
        [self presentMenuViewController];
    }
}

#pragma mark Gesture Recognizer Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // If pan back to pop (interactive pop) is enabled on a navigation controller, allow its gesture to dominate over
    // the menu swipe gesture
    if ([self.contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.contentViewController;
        if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer.enabled) {
            return NO;
        }
    }
  
    // Only allow a pan to begin if the starting point is on the left half of the screen
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !self.menuVisible) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.x < 0.5 * CGRectGetWidth(self.view.bounds)) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    // Delegate callback
    if([self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] &&
       [self.delegate respondsToSelector:@selector(sideMenuViewController:didRecognizePanGesture:)]) {
        [self.delegate sideMenuViewController:self didRecognizePanGesture:recognizer];
    }
    
    CGPoint point = [recognizer translationInView:self.view];
    
    // Pan gesture began
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // Delegate callback
        if (!self.menuVisible && [self.delegate conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideMenuViewController:willShowMenuViewController:)]) {
            [self.delegate sideMenuViewController:self willShowMenuViewController:self.menuViewController];
        }
        
        // Set the original point
        self.originalPoint = CGPointMake(self.contentViewController.view.center.x - 0.5 * CGRectGetWidth(self.contentViewController.view.bounds), self.contentViewController.view.center.y - 0.5 * CGRectGetHeight(self.contentViewController.view.bounds));
        
        // Reset frame and transform
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        self.menuViewController.view.frame = self.view.bounds;
        
        
        // Reset background image view
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView.transform = CGAffineTransformIdentity;
            self.backgroundImageView.frame = self.view.bounds;
        }
        self.backgroundImageView.alpha = 1.0;
        
        // End any editing
        [self.view.window endEditing:YES];
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        
        // Determine the delta between the original point and the current point
        CGFloat delta = self.menuVisible ? (point.x + self.originalPoint.x) / self.originalPoint.x :
                                            point.x / CGRectGetWidth(self.view.bounds);
        
        // Determine the scale of the content view
        CGFloat contentViewScale = (delta > 1.0)? self.contentViewScaleValue - ((0.1f / delta) * (delta - 1.0)) :
                                                  MAX(1.0 - (1.0 - self.contentViewScaleValue) * delta, self.contentViewScaleValue);
        
        // Determine the scale of the menu view
        CGFloat menuViewScale = (delta > 1.0)? 1.0f - ((0.1f / delta) * (delta - 1.0)) : MAX(1.5f - (0.5f * delta), 1.0);
        
        // Determine the scale of the background view
        CGFloat backgroundViewScale = MAX(1.7f - (0.7f * delta), 1.0);
    
        // Determine index of blurred background image to use
        self.blurredImageIndex = MIN(MAX(0.0, ([self.blurredBackgroundImages count] -1) * delta),
                                          [self.blurredBackgroundImages count] - 1);
        self.backgroundImageView.image = self.blurredBackgroundImages[self.blurredImageIndex];
        
        // Update menu view alpha and scale
        self.menuViewController.view.alpha = delta;
        self.menuViewController.view.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale);
        
        // Scale background image
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);
            if (backgroundViewScale < 1.0) {
                self.backgroundImageView.transform = CGAffineTransformIdentity;
            }
        }
        
        if (contentViewScale > 1.0) {
            if (!self.menuVisible) {
                self.contentViewController.view.transform = CGAffineTransformIdentity;
            }
            self.contentViewController.view.frame = self.view.bounds;
        } else {
            if (self.menuVisible) {
                [recognizer setTranslation:point inView:self.view];
            }
            // Translate and scale content view based on delta
            CGFloat contentOffset = (delta > 1.0 && point.x != 0.0)? point.x / (point.x * delta) : point.x;
            self.contentViewController.view.transform = CGAffineTransformMakeScale(contentViewScale, contentViewScale);
            self.contentViewController.view.transform = CGAffineTransformTranslate(self.contentViewController.view.transform,
                                                                                   contentOffset, 0);
        }
        
        [self updateStatusBar];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        // Determine the velocity of the pan and hide/show the menu accordingly
        CGPoint velocity = [recognizer velocityInView:self.view];
        if (velocity.x > 0) {
            [self showMenuViewControllerWithVelocity:velocity.x];
        } else {
            [self hideMenuViewControllerWithVelocity:velocity.x];
        }
    }
    
}

#pragma mark Overridden Setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if(!backgroundImage || backgroundImage == _backgroundImage) {
        return;
    }
    
    [self.blurredBackgroundImages removeAllObjects];
    
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.5];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        CGFloat blurFactor = 0.1;
        for(int i = 0; i < 20; ++i) {
            UIImage *blurredImage = [backgroundImage applyBlurWithRadius:blurFactor
                                                               tintColor:tintColor
                                                   saturationDeltaFactor:1.8
                                                               maskImage:nil];
            [self.blurredBackgroundImages addObject:blurredImage];
            blurFactor = MIN(blurFactor * 1.5, blurFactor + 1.0);
        }
        
        _backgroundImage = self.blurredBackgroundImages[0];
        dispatch_async(dispatch_get_main_queue(), ^ {
            self.backgroundImageView.image = self.blurredBackgroundImages[self.blurredImageIndex];
        });
    });
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if(self.contentViewController == contentViewController) {
        return;
    }
    
    CGRect frame                = _contentViewController.view.frame;
    CGAffineTransform transform = _contentViewController.view.transform;
    [self configureHideController:_contentViewController];
    
    _contentViewController = contentViewController;
    [self configureDisplayController:contentViewController frame:self.view.bounds];
    contentViewController.view.frame        = frame;
    contentViewController.view.transform    = transform;
    
    if(self.menuVisible) {
        [self addContentViewControllerMotionEffects];
    }
    
    if([contentViewController conformsToProtocol:@protocol(UTCSSideMenuViewControllerDelegate)]) {
        self.delegate = (id<UTCSSideMenuViewControllerDelegate>)contentViewController;
    } else {
        self.delegate = nil;
    }
    
    if([_contentViewController respondsToSelector:@selector(navigationBar)]) {
        UINavigationBar *navigationBar = [_contentViewController performSelector:@selector(navigationBar)];
        navigationBar.topItem.leftBarButtonItem = self.menuBarButtonItem;
    }
}

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated
{
    if(self.contentViewController == contentViewController) {
        return;
    }
    
    if (!animated) {
        [self setContentViewController:contentViewController];
    } else {
        contentViewController.view.alpha = 0.0;
        contentViewController.view.frame = self.contentViewController.view.bounds;
        [self.contentViewController.view addSubview:contentViewController.view];
        [UIView animateWithDuration:self.animationDuration animations: ^ {
            contentViewController.view.alpha = 1.0;
        } completion: ^ (BOOL finished) {
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
