//
//  UTCSLabMachineViewLayout.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabMachineViewLayout.h"

@implementation UTCSLabMachineViewLayout

- (CGPoint)labMachineView:(UTCSLabMachineView *)labMachineView positionForLabMachine:(UTCSLabMachine *)labMachine
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

- (NSInteger)numberOfLabMachineViews
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

@end
