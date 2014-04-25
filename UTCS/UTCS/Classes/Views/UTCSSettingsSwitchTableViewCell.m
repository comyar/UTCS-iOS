//
//  UTCSSettingsSwitchTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsSwitchTableViewCell.h"

@implementation UTCSSettingsSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cellSwitch = [UISwitch new];
        [self.contentView addSubview:_cellSwitch];
        
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.detailTextLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 0.1 * self.bounds.size.height, 0.75 * CGRectGetWidth(self.bounds), self.textLabel.bounds.size.height);
    
    self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.textLabel.frame.origin.y + CGRectGetHeight(self.textLabel.bounds), 0.6 * CGRectGetWidth(self.bounds), self.detailTextLabel.bounds.size.height);
    
    self.cellSwitch.center = CGPointMake(CGRectGetWidth(self.bounds) - 48.0, 0.5 * CGRectGetHeight(self.bounds));
}

@end
