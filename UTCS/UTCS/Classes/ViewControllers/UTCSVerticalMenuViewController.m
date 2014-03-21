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

@property (nonatomic) UIPanGestureRecognizer        *panGestureRecognizer;

@property (nonatomic) UIDynamicAnimator             *contentDynamicAnimator;

@property (nonatomic) UISnapBehavior                *contentSnapUpBehavior;

@property (nonatomic) UISnapBehavior                *contentSnapDownBehavior;

@property (nonatomic) UIDynamicItemBehavior         *contentDynamicItemBehavior;

@end


#pragma mark - UTCSVerticalMenuViewController Implementation

@implementation UTCSVerticalMenuViewController

- (instancetype)initWithMenuViewController:(UIViewController *)menuViewController contentViewController:(UIViewController *)contentViewController
{
    if(self = [super initWithNibName:nil bundle:nil]) {
        if(![contentViewController isKindOfClass:[UIViewController class]]) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"contentViewController argument must be an instance of UIViewController"
                                         userInfo:nil];
        }
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentDynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
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
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
}

- (void)hideMenu
{
    [self.contentDynamicAnimator removeBehavior:self.contentSnapDownBehavior];
    
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [self.contentDynamicAnimator addBehavior:self.contentDynamicItemBehavior];
    [self.contentDynamicAnimator addBehavior:self.contentSnapUpBehavior];
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    
    self.showingMenu = NO;
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return (self.isShowingMenu)? self.menuViewController.preferredStatusBarStyle : self.contentViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return !self.isShowingMenu;
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
    _menuViewController.view.frame = self.view.frame;
    [self.view addSubview:_menuViewController.view];
    [self addChildViewController:menuViewController];
    [_menuViewController didMoveToParentViewController:self];
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if(!contentViewController || _contentViewController == contentViewController) {
        return;
    } else if(_contentViewController) {
        [_contentViewController.view removeFromSuperview];
        [_contentViewController removeFromParentViewController];
    }
    
    _contentViewController = contentViewController;
    _contentViewController.view.frame = self.view.frame;
    [self.view addSubview:_contentViewController.view];
    [self addChildViewController:_contentViewController];
    [_contentViewController didMoveToParentViewController:self];
    
    self.contentDynamicItemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[_contentViewController.view]];
    self.contentDynamicItemBehavior.allowsRotation = NO;
    
    self.contentSnapUpBehavior = [[UISnapBehavior alloc]initWithItem:_contentViewController.view
                                                         snapToPoint:self.view.center];
    self.contentSnapUpBehavior.damping = 0.35;
    self.contentSnapDownBehavior = [[UISnapBehavior alloc]initWithItem:_contentViewController.view
                                                           snapToPoint:CGPointMake(self.view.center.x, 1.25 * CGRectGetHeight(self.view.bounds))];
    self.contentSnapDownBehavior.damping = 0.35;
}

@end
