//
//  UTCSSegmentedControlTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/26/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSegmentedControlTableViewCell.h"

@implementation UTCSSegmentedControlTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSegmentedControl:(UISegmentedControl *)segmentedControl
{
    _segmentedControl = segmentedControl;
    _segmentedControl.tintColor = [UIColor whiteColor];
    [self addSubview:_segmentedControl];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 0.1 * self.bounds.size.height, 0.75 * CGRectGetWidth(self.bounds), self.textLabel.bounds.size.height);
    
    
    
    self.segmentedControl.frame = CGRectMake(self.textLabel.frame.origin.x + 8.0,
                                             self.textLabel.frame.origin.y + CGRectGetHeight(self.textLabel.bounds) + 8.0,
                                             CGRectGetWidth(self.bounds) - 2.0 * self.textLabel.frame.origin.x - 16.0,
                                             CGRectGetHeight(self.bounds) - CGRectGetHeight(self.textLabel.bounds) -
                                             self.textLabel.frame.origin.y - 16.0);
}

@end
