//
//  UTCSLabView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;

#import "UTCSLabMachineView.h"

@interface UTCSLabView : UIView

- (instancetype)initWithFrame:(CGRect)frame numberOfMachines:(NSUInteger)machines;

@property (nonatomic, readonly) NSArray *machineViews;

@end
