//
//  UTCSLabMachineViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSContentViewController.h"
#import "UTCSLabView.h"


@interface UTCSLabMachineViewController : UTCSContentViewController <UTCSLabViewDataSource>

- (instancetype)initWithLayout:(UTCSLabViewLayout *)layout;

@property (nonatomic) NSDictionary                  *machines;
@property (nonatomic, readonly) UTCSLabViewLayout   *layout;

@end
