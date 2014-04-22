//
//  UTCSVerticalMenuViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSVerticalMenuViewController.h"


NSString * const UTCSVerticalMenuDisplayNotification = @"UTCSVerticalMenuDisplayNotification";




static const CGFloat snapBehaviorDamping            = 0.33;
static const CGFloat maximumYtoBeginRecognizePan    = 44.0;



#pragma mark - UTCSVerticalMenuViewController Class Extension

@interface UTCSVerticalMenuViewController ()

//
@property (nonatomic, getter = isShowingMenu) BOOL showingMenu;

//
@property (nonatomic) UITapGestureRecognizer        *tapGestureRecognizer;

//
@property (nonatomic) UIPanGestureRecognizer        *panGestureRecognizer;

//
@property (nonatomic) UIDynamicAnimator             *contentDynamicAnimator;

@property (nonatomic) UISnapBehavior                *contentSnapBehavior;

@property (nonatomic) UIDynamicItemBehavior         *contentDynamicItemBehavior;

@end


#pragma mark - UTCSVerticalMenuViewController Implementation

@implementation UTCSVerticalMenuViewController

- (instancetype)initWithMenuViewController:(UIViewController *)menuViewController
                     contentViewController:(UIViewController *)contentViewController
{
    if(self = [super initWithNibName:nil bundle:nil]) {
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didRecognizeTapGesture:)];
        self.tapGestureRecognizer.delegate = self;
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didRecognizerPanGesture:)];
        self.panGestureRecognizer.delegate = self;
        
        [self setMenuViewController:menuViewController];
        [self setContentViewController:contentViewController];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(didReceiveVerticalMenuDisplayNotification)
                                                    name:UTCSVerticalMenuDisplayNotification
                                                  object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark Gesture Recognizers

- (void)didRecognizerPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        static CGPoint initial;
        
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            
            initial = self.contentViewController.view.center;
            
        } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            
            self.contentViewController.view.center = CGPointMake(initial.x, initial.y + translation.y);
            
        } else {
            CGPoint velocity = [gestureRecognizer velocityInView:self.view];
            
            if (velocity.y > 1000) {
                [self showMenu];
            } else {
                [self hideMenu];
            }
            
        }
    }
}

- (void)didRecognizeTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == self.tapGestureRecognizer) {
        if(self.isShowingMenu) {
            [self hideMenu];
        }
    }
}

#pragma mark UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == self.tapGestureRecognizer) {
        return self.isShowingMenu;
    } else if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint location = [gestureRecognizer locationInView:self.contentViewController.view];
        if (location.y <= maximumYtoBeginRecognizePan) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark Using a UTCSVerticalMenuViewController

- (void)didReceiveVerticalMenuDisplayNotification
{
    if(self.isShowingMenu) {
        [self hideMenu];
    } else {
        [self showMenu];
    }
}

- (void)showMenu
{
    [self.contentDynamicAnimator removeBehavior:self.contentSnapBehavior];
    
    self.contentDynamicAnimator     = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.contentDynamicItemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[_contentViewController.view]];
    self.contentDynamicItemBehavior.allowsRotation = NO;

    self.contentSnapBehavior = [[UISnapBehavior alloc]initWithItem:_contentViewController.view
                                                           snapToPoint:CGPointMake(self.view.center.x, 1.33 * CGRectGetHeight(self.view.bounds))];
    self.contentSnapBehavior.damping = snapBehaviorDamping;
    
    [self.contentDynamicAnimator addBehavior:self.contentDynamicItemBehavior];
    [self.contentDynamicAnimator addBehavior:self.contentSnapBehavior];
    
    self.showingMenu = YES;
    
    [self enableUserInteraction:NO forViewController:self.contentViewController];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)hideMenu
{
    [self.contentDynamicAnimator removeBehavior:self.contentSnapBehavior];
    
    self.contentDynamicAnimator     = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.contentDynamicItemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[_contentViewController.view]];
    self.contentDynamicItemBehavior.allowsRotation = NO;

    
    self.contentSnapBehavior = [[UISnapBehavior alloc]initWithItem:_contentViewController.view
                                                         snapToPoint:self.view.center];
    self.contentSnapBehavior.damping = snapBehaviorDamping;
    
    
    [self.contentDynamicAnimator addBehavior:self.contentDynamicItemBehavior];
    [self.contentDynamicAnimator addBehavior:self.contentSnapBehavior];
    
    self.showingMenu = NO;
    
    [self enableUserInteraction:YES forViewController:self.contentViewController];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return !self.showingMenu;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)enableUserInteraction:(BOOL)enabled forViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass:[UINavigationController class]]) {
        for(UIViewController *childViewController in viewController.childViewControllers) {
            for(UIView *subview in childViewController.view.subviews) {
                if(subview.tag < NSIntegerMax) {
                    subview.userInteractionEnabled = enabled;
                }
            }
        }
    } else {
        for(UIView *subview in viewController.view.subviews) {
            if(subview.tag < NSIntegerMax) {
                subview.userInteractionEnabled = enabled;
            }
        }
    }
}

#pragma mark Setters

- (void)setMenuViewController:(UIViewController *)menuViewController
{
    if(!menuViewController || _menuViewController == menuViewController) {
        return;
    } else if(_menuViewController) {
        [_menuViewController.view removeFromSuperview];
        [_menuViewController removeFromParentViewController];
    }
    
    _menuViewController = menuViewController;
    _menuViewController.view.frame = self.view.bounds;
    [self.view addSubview:_menuViewController.view];
    [self addChildViewController:_menuViewController];
    [_menuViewController didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if(!contentViewController || _contentViewController == contentViewController) {
        [self hideMenu];
        return;
    } else if(_contentViewController) {
        [_contentViewController.view removeGestureRecognizer:self.panGestureRecognizer];
        [_contentViewController.view removeGestureRecognizer:self.tapGestureRecognizer];
        [_contentViewController willMoveToParentViewController:nil];
        [_contentViewController.view removeFromSuperview];
        [_contentViewController removeFromParentViewController];
        
        contentViewController.view.frame = _contentViewController.view.frame;
        [self addChildViewController:contentViewController];
        [self.view addSubview:contentViewController.view];
        [contentViewController didMoveToParentViewController:self];
        
        [self configureContentViewController:contentViewController];
        [self hideMenu];
        
    } else {
        contentViewController.view.frame = self.view.bounds;
        [self addChildViewController:contentViewController];
        [self.view addSubview:contentViewController.view];
        [contentViewController didMoveToParentViewController:self];
        [self configureContentViewController:contentViewController];
    }
}

#pragma mark Configure Content View Controller

- (void)configureContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    [_contentViewController.view addGestureRecognizer:self.tapGestureRecognizer];
    [_contentViewController.view addGestureRecognizer:self.panGestureRecognizer];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
