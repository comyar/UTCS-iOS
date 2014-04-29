//
//  UTCSTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSBouncyTableViewCell.h"


static const CGFloat animationDuration = 0.3;

@interface UTCSBouncyTableViewCell ()
@property (nonatomic) CGRect originalContentBounds;
@end


@implementation UTCSBouncyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.originalContentBounds = self.bounds;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.originalContentBounds = self.bounds;
}

- (void)bounceWithDirection:(UTCSBouncyTableViewCellBounceDirection)bounceDirection
{
    NSValue *scaleValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    
    if (bounceDirection == UTCSBouncyTableViewCellBounceDirectionDown) {
        scaleValue = [NSValue valueWithCGPoint:CGPointMake(0.925, 0.925)];
    }
    
    NSNumber *alphaValue = (bounceDirection == UTCSBouncyTableViewCellBounceDirectionDown)? @(0.5) : @(1.0);
    
    POPSpringAnimation *springAnimation = [self.contentView pop_animationForKey:@"bounce"];
    POPSpringAnimation *alphaAnimation = [self.contentView pop_animationForKey:@"alpha"];
    
    if (alphaAnimation) {
        alphaAnimation.toValue = alphaValue;
    } else {
        alphaAnimation = [POPSpringAnimation animation];
        alphaAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        alphaAnimation.springBounciness = 20.0;
        alphaAnimation.springSpeed = 20.0;
        alphaAnimation.toValue = alphaValue;
        [self.contentView pop_addAnimation:alphaAnimation forKey:@"alpha"];
    }
    
    if (springAnimation) {
        springAnimation.toValue = scaleValue;
    } else {
        springAnimation = [POPSpringAnimation animation];
        springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
        springAnimation.springBounciness = 20.0;
        springAnimation.springSpeed = 20.0;
        springAnimation.toValue = scaleValue;
        [self.contentView pop_addAnimation:springAnimation forKey:@"bounce"];
    }
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

@end
