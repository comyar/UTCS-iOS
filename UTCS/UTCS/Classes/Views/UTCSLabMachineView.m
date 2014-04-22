//
//  UTCSLabMachineView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabMachineView.h"

@implementation UTCSLabMachineView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 0.5 * frame.size.width;
        [self addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)didTouchUpInside
{
    if ([self.delegate conformsToProtocol:@protocol(UTCSLabMachineViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(didTouchUpInsideLabMachineView:)]) {
        [self.delegate didTouchUpInsideLabMachineView:self];
    }
}

@end
