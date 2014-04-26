//
//  UTCSLabView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;
#import "UTCSLabViewLayout.h"

@interface UTCSLabView : UIView

- (instancetype)initWithFrame:(CGRect)frame layout:(UTCSLabViewLayout *)layout;

@property (nonatomic, readonly) UTCSLabViewLayout   *layout;
@property (nonatomic, readonly) NSArray *machineViews;

@end
