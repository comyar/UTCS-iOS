//
//  UTCSLabView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabView.h"


@implementation UTCSLabView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfMachines:0];
}

- (instancetype)initWithFrame:(CGRect)frame numberOfMachines:(NSUInteger)machines
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect machineViewBounds = CGRectMake(0.0, 0.0, frame.size.width / 20.0, frame.size.width / 20.0);
        
        NSMutableArray *machineViews = [NSMutableArray new];
        for (int i = 0; i < machines; ++i) {
            UTCSLabMachineView *machineView = [[UTCSLabMachineView alloc]initWithFrame:machineViewBounds];
            machineView.hidden = YES;
            [self addSubview:machineView];
            [machineViews addObject:machineView];
        }
        
        _machineViews = machineViews;
    }
    return self;
}

@end
