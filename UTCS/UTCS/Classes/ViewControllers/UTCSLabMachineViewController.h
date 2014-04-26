//
//  UTCSLabMachineViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;

#import "UTCSContentViewController.h"
#import "UTCSLabViewLayout.h"


@interface UTCSLabMachineViewController : UTCSContentViewController

- (instancetype)initWithLayout:(UTCSLabViewLayout *)layout;


@property (nonatomic) NSArray *machines;
@property (nonatomic, readonly) UTCSLabViewLayout *layout;

@end
