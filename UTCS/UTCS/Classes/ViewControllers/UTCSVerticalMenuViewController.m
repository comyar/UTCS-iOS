//
//  UTCSVerticalMenuViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSVerticalMenuViewController.h"


NSString * const UTCSVerticalMenuDisplayNotification = @"UTCSVerticalMenuDisplayNotification";
const CGFloat animationDuration = 0.25;

#pragma mark - UTCSVerticalMenuViewController Class Extension

@interface UTCSVerticalMenuViewController ()

@property (nonatomic, getter = isShowingMenu) BOOL showingMenu;

@property (nonatomic) UITapGestureRecognizer        *tapGestureRecognizer;

@property (nonatomic) UIPanGestureRecognizer        *panGestureRecognizer;

@property (nonatomic) UIDynamicAnimator             *contentDynamicAnimator;

@property (nonatomic) UISnapBehavior                *contentSnapUpBehavior;

@property (nonatomic) UISnapBehavior                *contentSnapDownBehavior;

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
        
        [self setMenuViewController:menuViewController];
        [self setContentViewController:contentViewController];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(didReceiveVerticalMenuDisplayNotification)
                                                    name:UTCSVerticalMenuDisplayNotification
                                                  object:nil];
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == self.tapGestureRecognizer) {
        return self.isShowingMenu;
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentDynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
}

- (void)didRecognizeTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == self.tapGestureRecognizer) {
        if(self.isShowingMenu) {
            [self hideMenu];
        }
    }
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
    [self.contentDynamicAnimator removeBehavior:self.contentSnapUpBehavior];
    
    [self.contentDynamicAnimator addBehavior:self.contentDynamicItemBehavior];
    [self.contentDynamicAnimator addBehavior:self.contentSnapDownBehavior];
    
    self.showingMenu = YES;
    
    [self enableUserInteraction:NO forViewController:self.contentViewController];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)hideMenu
{
    [self.contentDynamicAnimator removeBehavior:self.contentSnapDownBehavior];
    
    [self.contentDynamicAnimator addBehavior:self.contentDynamicItemBehavior];
    [self.contentDynamicAnimator addBehavior:self.contentSnapUpBehavior];
    
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

#pragma mark Property Setters

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
    [self addChildViewController:menuViewController];
    [_menuViewController didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if(!contentViewController || _contentViewController == contentViewController) {
        [self hideMenu];
        return;
    } else if(_contentViewController) {
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

- (void)configureContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    [_contentViewController.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.contentDynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.contentDynamicItemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[_contentViewController.view]];
    self.contentDynamicItemBehavior.allowsRotation = NO;
    self.contentDynamicItemBehavior.resistance = 2.0;
    
    self.contentSnapUpBehavior = [[UISnapBehavior alloc]initWithItem:_contentViewController.view
                                                         snapToPoint:self.view.center];
    self.contentSnapUpBehavior.damping = 0.35;
    
    self.contentSnapDownBehavior = [[UISnapBehavior alloc]initWithItem:_contentViewController.view
                                                           snapToPoint:CGPointMake(self.view.center.x, 1.33 * CGRectGetHeight(self.view.bounds))];
    self.contentSnapDownBehavior.damping = 0.35;
}

@end
