//
//  UTCSLabMachineView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabMachineView.h"

@implementation UTCSLabMachineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.cornerRadius = 0.0 * frame.size.width;
}

@end
