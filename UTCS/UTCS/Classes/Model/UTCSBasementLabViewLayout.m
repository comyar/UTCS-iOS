//
//  UTCSBasementLabViewLayout.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSBasementLabViewLayout.h"

@implementation UTCSBasementLabViewLayout

- (NSInteger)numberOfLabMachineViews
{
    return 1;
}

- (CGPoint)labView:(UTCSLabView *)labView positionForLabMachine:(UTCSLabMachine *)labMachine
{
    return CGPointMake(128.0, 190.0);
}

@end
