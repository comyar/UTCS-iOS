//
//  UTCSLabMachineViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;

#import "UTCSLabView.h"
#import "FBShimmeringView.h"

/**
 */
@interface UTCSLabMachineViewController : UIViewController <UTCSLabViewDataSource>

/**
 */
- (instancetype)initWithLayout:(UTCSLabViewLayout *)layout;

/**
 */
@property (nonatomic) NSDictionary                  *machines;

/**
 */
@property (nonatomic) CGPoint                       imageOffset;

/**
 */
@property (nonatomic) FBShimmeringView              *shimmeringView;

/**
 */
@property (nonatomic, readonly) UIImageView         *backgroundImageView;

/**
 */
@property (nonatomic, readonly) UTCSLabViewLayout   *layout;

@end
