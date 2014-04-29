//
//  UTCSSlideNavigationPushAnimator.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;
#import <POP/POP.h>

@interface UTCSSlideNavigationAnimator : NSObject <UIViewControllerAnimatedTransitioning, POPAnimationDelegate>

@property (nonatomic, getter = isPushing) BOOL pushing;

@end
