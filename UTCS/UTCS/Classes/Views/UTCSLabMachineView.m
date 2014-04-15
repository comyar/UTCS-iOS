//
//  UTCSLabMachineView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabMachineView.h"

@implementation UTCSLabMachineView

- (instancetype)initWithFrame:(CGRect)frame identifier:(NSString *)identifier
{
    if(self = [super initWithFrame:frame]) {
        _identifier = identifier;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.cornerRadius = 0.5 * self.frame.size.height;
}

@end
