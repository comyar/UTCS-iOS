//
//  UTCSSlideNavigationPushAnimator.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <POP/POP.h>
#import "UTCSSlideNavigationAnimator.h"

@interface UTCSSlideNavigationAnimator ()
@property (nonatomic) id<UIViewControllerContextTransitioning> transitionContext;
@end


@implementation UTCSSlideNavigationAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.0;
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
    
    POPSpringAnimation *toSpringAnimation = [POPSpringAnimation animation];
    toSpringAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    toSpringAnimation.toValue = [NSValue valueWithCGRect:toDestinationFrame];
    toSpringAnimation.springBounciness = 5.0;
    toSpringAnimation.springSpeed = 10.0;
    toSpringAnimation.delegate = self;
    
    POPSpringAnimation *fromSpringAnimation = [POPSpringAnimation animation];
    fromSpringAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    fromSpringAnimation.toValue = [NSValue valueWithCGRect:fromDestinationFrame];
    fromSpringAnimation.springBounciness = 5.0;
    fromSpringAnimation.springSpeed = 10.0;
    
    self.transitionContext = transitionContext;
    
    
    [toViewController.view pop_addAnimation:toSpringAnimation       forKey:@"toSpringAnimation"];
    [fromViewController.view pop_addAnimation:fromSpringAnimation   forKey:@"fromSpringAnimation"];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    [self.transitionContext completeTransition:finished];
    self.transitionContext = nil;
}

@end
