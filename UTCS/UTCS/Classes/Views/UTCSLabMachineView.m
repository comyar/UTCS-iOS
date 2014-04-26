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
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 0.5 * frame.size.width;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
