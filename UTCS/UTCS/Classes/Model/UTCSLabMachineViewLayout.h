//
//  UTCSLabMachineViewLayout.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

@class UTCSLabMachine;
@class UTCSLabMachineView;


@interface UTCSLabMachineViewLayout : NSObject

- (CGPoint)labMachineView:(UTCSLabMachineView *)labMachineView positionForLabMachine:(UTCSLabMachine *)labMachine;

@end
