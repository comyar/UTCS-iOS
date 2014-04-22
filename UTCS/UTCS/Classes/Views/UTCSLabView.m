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
        
        CGRect machineViewBounds = CGRectMake(0.0, 0.0, frame.size.width / 30.0, frame.size.width / 30.0);
        
        NSMutableArray *machineViews = [NSMutableArray new];
        for (int i = 0; i < machines; ++i) {
            UTCSLabMachineView *machineView = [[UTCSLabMachineView alloc]initWithFrame:machineViewBounds];
            [machineViews addObject:machineView];
        }
        
        _machineViews = machineViews;
        
    }
    return self;
}

@end
