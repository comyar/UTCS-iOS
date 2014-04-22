//
//  UTCSLabMachineViewLayout.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

@class UTCSLabMachine;
@class UTCSLabView;


@interface UTCSLabMachineViewLayout : NSObject

/**
 */
- (NSInteger)numberOfLabMachineViews;

/**
 */
- (CGPoint)labMachineView:(UTCSLabView *)labView positionForLabMachine:(UTCSLabMachine *)labMachine;

@end
