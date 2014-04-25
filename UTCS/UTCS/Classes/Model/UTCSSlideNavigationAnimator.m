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
    NSLog(@"push transition duration");
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"push animation transition");
    UIViewController* toViewController      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGSize viewSize = [transitionContext containerView].bounds.size;
    CGRect toStartFrame = CGRectMake((self.pushing)? 1.5 * viewSize.width : -1.5  * viewSize.width, 0.0,
                                 CGRectGetWidth(toViewController.view.bounds), CGRectGetHeight(toViewController.view.bounds));
    
    CGRect toDestinationFrame   = fromViewController.view.frame;
    CGRect fromDestinationFrame = CGRectMake((self.pushing)? -1.5 * viewSize.width : 1.5  * viewSize.width, 0.0,
                                    CGRectGetWidth(toViewController.view.bounds), CGRectGetHeight(toViewController.view.bounds));
    
    toViewController.view.alpha = 0.0;
    toViewController.view.frame = toStartFrame;
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        toViewController.view.frame     = toDestinationFrame;
        toViewController.view.alpha     = 1.0;
        
        fromViewController.view.frame  = fromDestinationFrame;
        fromViewController.view.alpha   = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
