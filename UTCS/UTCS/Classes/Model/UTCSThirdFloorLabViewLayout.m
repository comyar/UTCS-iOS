//
//  UTCSThirdFloorLabViewLayout.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSThirdFloorLabViewLayout.h"

@implementation UTCSThirdFloorLabViewLayout

- (NSInteger)numberOfLabMachineViews
{
    return 1;
}

- (CGPoint)labView:(UTCSLabView *)labView positionForLabMachine:(UTCSLabMachine *)labMachine
{
    return CGPointMake(64.0, 64.0);
}

@end
