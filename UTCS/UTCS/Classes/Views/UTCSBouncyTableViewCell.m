//
//  UTCSTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UTCSBouncyTableViewCell.h"


#pragma mark - Constants

// Final scale of the content view when bouncing downwards
static const CGFloat bounceDownScale        = 0.925;

// Final alpha of the content view when bouncing downwards
static const CGFloat bounceDownAlpha        = 0.5;

// Bounciness of the POPSpringAnimation
static const CGFloat springBounciness       = 20.0;

// Speed of the POPSpringAnimation
static const CGFloat springSpeed            = 20.0;

// Key to identify the alpha animation
static NSString * const alphaAnimationKey   = @"alpha";

// Key to identify the bounce animation
static NSString * const bounceAnimationKey  = @"bounce";


#pragma mark - UTCSBouncyTableViewCell Implementation

@implementation UTCSBouncyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font             = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.detailTextLabel.font       = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        self.detailTextLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.selectionStyle             = UITableViewCellSelectionStyleNone;
        self.backgroundColor            = [UIColor clearColor];
        self.textLabel.textColor        = [UIColor whiteColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted && animated) {
        [self bounceWithDirection:UTCSBouncyTableViewCellBounceDirectionDown];
    } else if (!highlighted & animated) {
        [self bounceWithDirection:UTCSBouncyTableViewCellBounceDirectionUp];
    }
}

#pragma mark Using a UTCSBouncyTableViewCell

- (void)bounceWithDirection:(UTCSBouncyTableViewCellBounceDirection)bounceDirection
{
    // Determine the final scale of the content view
    NSValue *scaleValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    if (bounceDirection == UTCSBouncyTableViewCellBounceDirectionDown) {
        scaleValue = [NSValue valueWithCGPoint:CGPointMake(bounceDownScale, bounceDownScale)];
    }
    
    // Determine the final alpha of the content view
    NSNumber *alphaValue = (bounceDirection == UTCSBouncyTableViewCellBounceDirectionDown)? @(bounceDownAlpha) : @(1.0);
    
    // Retrieve the animations in case an animations is already in progress
    POPSpringAnimation  *springAnimation = [self.contentView pop_animationForKey:bounceAnimationKey];
    POPBasicAnimation   *alphaAnimation  = [self.contentView pop_animationForKey:alphaAnimationKey];
    
    // Initialize or update the alpha animation
    if (alphaAnimation) {
        alphaAnimation.toValue = alphaValue;
    } else {
        alphaAnimation = ({
            POPBasicAnimation *animation = [POPBasicAnimation animation];
            animation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
            animation.toValue = alphaValue;
            animation;
        });
        [self.contentView pop_addAnimation:alphaAnimation forKey:alphaAnimationKey];
    }
    
    // Initialize of update the spring animations
    if (springAnimation) {
        springAnimation.toValue = scaleValue;
    } else {
        springAnimation = ({
            POPSpringAnimation *animation = [POPSpringAnimation animation];
            animation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
            animation.springBounciness = springBounciness;
            animation.springSpeed = springSpeed;
            animation.toValue = scaleValue;
            animation;
        });
        [self.contentView pop_addAnimation:springAnimation forKey:bounceAnimationKey];
    }
}

@end
