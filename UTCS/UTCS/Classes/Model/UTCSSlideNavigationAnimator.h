//
//  UTCSSlideNavigationPushAnimator.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

@interface UTCSSlideNavigationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, getter = isPushing) BOOL pushing;

@end
