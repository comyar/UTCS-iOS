//
//  UTCSNavigationControllerDelegate.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNavigationControllerDelegate.h"
#import "UTCSNavigationController.h"
#import "UTCSSlideNavigationAnimator.h"


@interface UTCSNavigationControllerDelegate ()

@property (nonatomic) UIPanGestureRecognizer                *panGestureRecognizer;
@property (nonatomic) UIPercentDrivenInteractiveTransition  *interactionController;

@property (nonatomic) UTCSSlideNavigationAnimator       *animator;

@end


@implementation UTCSNavigationControllerDelegate

- (instancetype)init
{
    if (self = [super init]) {
        
        self.animator               = [UTCSSlideNavigationAnimator new];
        
        self.panGestureRecognizer   = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didRecognizePanGesture:)];
    }
    return self;
}

- (void)setNavigationController:(UTCSNavigationController *)navigationController
{
    [_navigationController.view removeGestureRecognizer:self.panGestureRecognizer];
    _navigationController = navigationController;
    [_navigationController.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)didRecognizePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIView* view = self.navigationController.view;
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            CGPoint location = [gestureRecognizer locationInView:view];
            if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
                self.interactionController = [UIPercentDrivenInteractiveTransition new];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [gestureRecognizer translationInView:view];
            CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
            [self.interactionController updateInteractiveTransition:d];
        } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if ([gestureRecognizer velocityInView:view].x > 0) {
                [self.interactionController finishInteractiveTransition];
            } else {
                [self.interactionController cancelInteractiveTransition];
            }
            self.interactionController = nil;
        }
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop ||
        operation == UINavigationControllerOperationPush) {
        self.animator.pushing = (operation == UINavigationControllerOperationPush);
        return self.animator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}



@end
