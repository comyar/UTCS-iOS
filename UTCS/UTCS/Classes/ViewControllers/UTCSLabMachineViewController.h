//
//  UTCSLabMachineViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;


#import "UTCSLabMachineViewLayout.h"

@interface UTCSLabMachineViewController : UIViewController

- (instancetype)initWithLayout:(UTCSLabMachineViewLayout *)layout;

- (void)layoutLabMachineViewsWithLabMachines:(NSArray *)labMachines;


@property (nonatomic, readonly) UTCSLabMachineViewLayout *layout;

@end
