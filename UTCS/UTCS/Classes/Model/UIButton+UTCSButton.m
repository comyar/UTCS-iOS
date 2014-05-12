//
//  UIButton+UTCSBouncyButton.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UIButton+UTCSButton.h"
#import "UTCSVerticalMenuViewController.h"
#import <Tweaks/FBTweakInline.h>

@implementation UIButton (UTCSButton)


+ (UIButton *)bouncyButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:button action:@selector(bounceDown) forControlEvents:UIControlEventTouchDown];
    [button addTarget:button action:@selector(reset) forControlEvents:UIControlEventTouchCancel];
    [button addTarget:button action:@selector(reset) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:button action:@selector(reset) forControlEvents:UIControlEventTouchDragOutside];
    [button addTarget:button action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:button action:@selector(reset) forControlEvents:UIControlEventTouchUpOutside];
    return button;
}

+ (UIButton *)menuButton
{
    UIButton *button = [UIButton bouncyButton];
    button.tag = NSIntegerMax;
    button.frame = CGRectMake(0.0, 0.0, 44, 44);
    [button addTarget:button action:@selector(menuNotification) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *image = [[UIImage imageNamed:@"menu"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.tintColor = [UIColor whiteColor];
    imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    imageView.center = CGPointMake(0.5 * CGRectGetWidth(button.bounds), 0.5 * CGRectGetHeight(button.bounds));
    [button addSubview:imageView];
    
    return button;
}

- (void)menuNotification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:UTCSVerticalMenuDisplayNotification object:nil userInfo:nil];
}

- (void)bounceDown
{
    POPSpringAnimation *springAnimation = [self pop_animationForKey:@"bounce"];
    POPBasicAnimation *alphaAnimation = [self pop_animationForKey:@"alpha"];
    
    NSValue *scaleValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
    
    if (springAnimation) {
        springAnimation.toValue = scaleValue;
    } else {
        springAnimation = [POPSpringAnimation animation];
        springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
        springAnimation.springBounciness = FBTweakValue(@"UIButton", @"Bouncy Button", @"Spring Bounciness", 20.0);
        springAnimation.springSpeed = FBTweakValue(@"UIButton", @"Bouncy Button", @"Spring Speed", 20.0);
        springAnimation.toValue = scaleValue;
        [self pop_addAnimation:springAnimation forKey:@"bounce"];
    }
    
    CGFloat alpha = 0.5;
    if (alphaAnimation) {
        alphaAnimation.toValue = @(alpha);
    } else {
        alphaAnimation = [POPBasicAnimation animation];
        alphaAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        alphaAnimation.toValue = @(alpha);
        [self pop_addAnimation:alphaAnimation forKey:@"alpha"];
    }
    
}

- (void)reset
{
    POPSpringAnimation *springAnimation = [self pop_animationForKey:@"bounce"];
    POPBasicAnimation   *alphaAnimation = [self pop_animationForKey:@"alpha"];
    
    
    NSValue *scaleValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    
    if (springAnimation) {
        springAnimation.toValue = scaleValue;
    } else {
        springAnimation = [POPSpringAnimation animation];
        springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
        springAnimation.springBounciness = 20.0;
        springAnimation.springSpeed = 20.0;
        springAnimation.toValue = scaleValue;
        [self pop_addAnimation:springAnimation forKey:@"bounce"];
    }
    
    CGFloat alpha = 1.0;
    if (alphaAnimation) {
        alphaAnimation.toValue = @(alpha);
    } else {
        alphaAnimation = [POPBasicAnimation animation];
        alphaAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        alphaAnimation.toValue = @(alpha);
        [self pop_addAnimation:alphaAnimation forKey:@"alpha"];
    }
}

@end
