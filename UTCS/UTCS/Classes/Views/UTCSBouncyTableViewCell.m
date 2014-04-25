//
//  UTCSTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSBouncyTableViewCell.h"


static const CGFloat animationDuration = 0.3;

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
    }
    return self;
}

- (void)bounceWithDirection:(UTCSBouncyTableViewCellBounceDirection)bounceDirection
{
    [UIView animateWithDuration:animationDuration/3.0 animations:^{
        self.contentView.transform = (bounceDirection == UTCSBouncyTableViewCellBounceDirectionDown)? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration/3.0 animations:^{
            self.contentView.transform = (bounceDirection == UTCSBouncyTableViewCellBounceDirectionDown)? CGAffineTransformMakeScale(0.95, 0.95) : CGAffineTransformMakeScale(0.975, 0.975);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration/3.0 animations:^{
                self.contentView.transform = (bounceDirection == UTCSBouncyTableViewCellBounceDirectionDown)? CGAffineTransformMakeScale(0.925, 0.925) : CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.contentView.alpha = (bounceDirection == UTCSBouncyTableViewCellBounceDirectionDown)? 0.5 : 1.0;
    }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self bounceWithDirection:UTCSBouncyTableViewCellBounceDirectionDown];
    } else {
       [self bounceWithDirection:UTCSBouncyTableViewCellBounceDirectionUp];
    }
}

@end
