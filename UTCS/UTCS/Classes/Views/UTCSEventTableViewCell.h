//
//  UTCSEventTableViewCell.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTCSTableViewCell.h"

@interface UTCSEventTableViewCell : UTCSTableViewCell

@property (nonatomic) UIColor *tagColor;
@property (nonatomic, readonly) UILabel *monthLabel;
@property (nonatomic, readonly) UILabel *dayLabel;
@property (nonatomic, readonly) UILabel *tagLabel;

@end
