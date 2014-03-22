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
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didRecognizePanGesture:)];
        self.panGestureRecognizer.delegate = self;
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didRecognizeTapGesture:)];
        self.tapGestureRecognizer.delegate = self;
        
        [self setMenuViewController:menuViewController];
        [self setContentViewController:(UIViewController *)contentViewController];
        
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

- (void)didRecognizePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.contentViewController.view];
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
    }
    
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.contentViewController.view.transform = CGAffineTransformMakeTranslation(0, translation.y);
        
        
        
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        if(point.y < self.view.center.y) {
            [self hideMenu];
        } else {
            [self showMenu];
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
    
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [self.contentDynamicAnimator addBehavior:self.contentDynamicItemBehavior];
    [self.contentDynamicAnimator addBehavior:self.contentSnapDownBehavior];
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    
    self.showingMenu = YES;
    if([self.contentViewController respondsToSelector:@selector(verticalMenuViewController:didShowMenuViewController:)]) {
        [(id<UTCSVerticalMenuViewControllerDelegate>)self.contentViewController verticalMenuViewController:self
                                                                                 didShowMenuViewController:self.menuViewController];
    }
    
    if([self.contentViewController isKindOfClass:[UINavigationController class]]) {
        for(UIViewController *viewController in self.contentViewController.childViewControllers) {
            viewController.view.userInteractionEnabled = NO;
        }
    } else {
        self.contentViewController.view.userInteractionEnabled = NO;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)hideMenu
{
    [self.contentDynamicAnimator removeBehavior:self.contentSnapDownBehavior];
    
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [self.contentDynamicAnimator addBehavior:self.contentDynamicItemBehavior];
    [self.contentDynamicAnimator addBehavior:self.contentSnapUpBehavior];
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    
    self.contentViewController.view.userInteractionEnabled = YES;
    for(UIView *subview in self.contentViewController.view.subviews) {
        subview.userInteractionEnabled = YES;
    }
    
    self.showingMenu = NO;
    if([self.contentViewController respondsToSelector:@selector(verticalMenuViewController:didHideMenuViewController:)]) {
        [(id<UTCSVerticalMenuViewControllerDelegate>)self.contentViewController verticalMenuViewController:self didHideMenuViewController:self.menuViewController];
    }
    
    if([self.contentViewController isKindOfClass:[UINavigationController class]]) {
        for(UIViewController *viewController in self.contentViewController.childViewControllers) {
            viewController.view.userInteractionEnabled = YES;
        }
    } else {
        self.contentViewController.view.userInteractionEnabled = YES;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//- (BOOL)prefersStatusBarHidden
//{
//    return !self.isShowingMenu;
//}

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
        return;
    } else if(_contentViewController) {
        [_contentViewController.view removeFromSuperview];
        [_contentViewController removeFromParentViewController];
        [_contentViewController.view removeGestureRecognizer:self.tapGestureRecognizer];
    }
    
    _contentViewController = contentViewController;
    _contentViewController.view.frame = self.view.bounds;
    [self.view addSubview:_contentViewController.view];
    [self addChildViewController:_contentViewController];
    [_contentViewController didMoveToParentViewController:self];
    
    [self.contentViewController.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
//    [_contentViewController.view addGestureRecognizer:self.panGestureRecognizer];
    
    self.contentDynamicItemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[_contentViewController.view]];
    self.contentDynamicItemBehavior.allowsRotation = NO;
    self.contentDynamicItemBehavior.resistance = 2.0;
    
    self.contentSnapUpBehavior = [[UISnapBehavior alloc]initWithItem:_contentViewController.view
                                                         snapToPoint:self.view.center];
    self.contentSnapUpBehavior.damping = 0.35;
    self.contentSnapDownBehavior = [[UISnapBehavior alloc]initWithItem:_contentViewController.view
                                                           snapToPoint:CGPointMake(self.view.center.x, 1.25 * CGRectGetHeight(self.view.bounds))];
    self.contentSnapDownBehavior.damping = 0.35;
}

@end
