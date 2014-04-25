//
//  UTCSSlideNavigationPushAnimator.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSlideNavigationAnimator.h"

@implementation UTCSSlideNavigationAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGSize viewSize = [transitionContext containerView].bounds.size;
    CGRect toStartFrame = CGRectMake((self.pushing)? viewSize.width : -viewSize.width, 0.0,
                                 CGRectGetWidth(toViewController.view.bounds), CGRectGetHeight(toViewController.view.bounds));
    
    CGRect toDestinationFrame   = CGRectMake(0.0, 0.0, CGRectGetWidth(toViewController.view.bounds),
                                             CGRectGetHeight(toViewController.view.bounds));
    
    CGRect fromDestinationFrame = CGRectMake((self.pushing)? -viewSize.width : viewSize.width, 0.0,
                                    CGRectGetWidth(toViewController.view.bounds), CGRectGetHeight(toViewController.view.bounds));
    
    toViewController.view.frame = toStartFrame;
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        toViewController.view.frame     = toDestinationFrame;
        
        fromViewController.view.frame  = fromDestinationFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
