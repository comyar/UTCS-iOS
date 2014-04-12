//
//  UTCSButton.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/11/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSButton.h"

static const CGFloat animationDuration = 0.3;

@implementation UTCSButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(didTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didDragExit) forControlEvents:UIControlEventTouchDragExit];
        [self addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)didTouchDown
{
    self.alpha = 0.5;
    CGPoint center = self.center;
    [UIView animateWithDuration:animationDuration/3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.center = center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration/3 animations:^{
            self.transform = CGAffineTransformMakeScale(0.95, 0.95);
            self.center = center;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration/3 animations:^{
                self.transform = CGAffineTransformMakeScale(0.925, 0.925);
                self.center = center;
            }];
        }];
    }];
}

- (void)didTouchUpInside
{
    [self reset];
}

- (void)didDragExit
{
    [self reset];
}

- (void)reset
{
    self.alpha = 1.0;
    CGPoint center = self.center;
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.center = center;
    }];
}

@end
