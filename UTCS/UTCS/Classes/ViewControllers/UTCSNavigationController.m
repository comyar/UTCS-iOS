//
//  UTCSNavigationController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSNavigationController.h"
#import "UTCSSlideNavigationAnimator.h"


@interface UTCSNavigationController ()
@property (nonatomic) UTCSSlideNavigationAnimator *animator;
@property (nonatomic) UIPercentDrivenInteractiveTransition* interactionController;
@end


@implementation UTCSNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.animator = [UTCSSlideNavigationAnimator new];
        self.interactionController = [UIPercentDrivenInteractiveTransition new];
        _backgroundImageView = [UIImageView new];
        [self.view addSubview:self.backgroundImageView];
        [self.view sendSubviewToBack:self.backgroundImageView];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.backgroundImageView.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return self.animator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}

@end
