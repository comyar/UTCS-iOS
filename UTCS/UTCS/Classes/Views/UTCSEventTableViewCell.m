//
//  UTCSEventTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventTableViewCell.h"

@implementation UTCSEventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.numberOfLines = 4;
        
        self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.detailTextLabel.numberOfLines = 1;
        
        _monthLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor whiteColor];
            label;
        });
        [self.contentView addSubview:_monthLabel];
        
        _dayLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28];
            label.textAlignment = NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor whiteColor];
            label;
        });
        [self.contentView addSubview:_dayLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dayLabel.frame = CGRectMake(0.0, 0.0, 56, 28);
    self.dayLabel.center = CGPointMake(0.5 * CGRectGetWidth(self.dayLabel.bounds), self.center.y);
    
    self.textLabel.frame = ({
        CGRect frame = self.textLabel.frame;
        frame.origin.x = self.dayLabel.frame.origin.x + CGRectGetWidth(self.dayLabel.bounds);
        frame.size.width = CGRectGetWidth(self.bounds) - self.dayLabel.frame.origin.x - CGRectGetWidth(self.dayLabel.bounds) - 8.0;
        frame;
    });
    
    self.detailTextLabel.frame = ({
        CGRect frame = self.detailTextLabel.frame;
        frame.origin.x = self.dayLabel.frame.origin.x + CGRectGetWidth(self.dayLabel.bounds);
        frame.size.width = CGRectGetWidth(self.detailTextLabel.bounds) - self.dayLabel.frame.origin.x - CGRectGetWidth(self.dayLabel.bounds);
        frame;
    });
}

@end
