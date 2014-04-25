//
//  UTCSEventTableViewCell.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTCSBouncyTableViewCell.h"

@interface UTCSEventTableViewCell : UTCSBouncyTableViewCell

@property (nonatomic, readonly) CAShapeLayer    *typeStripeLayer;
@property (nonatomic, readonly) UILabel         *monthLabel;
@property (nonatomic, readonly) UILabel         *dayLabel;

@end
