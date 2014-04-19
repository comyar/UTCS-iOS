//
//  UTCSEventTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventTableViewCell.h"

static const CGFloat calendarDateWidth  = 64.0;
static const CGFloat dayLabelFontSize   = 40.0;
static const CGFloat monthLabelFontSize = 14.0;

@implementation UTCSEventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.numberOfLines = 4;
        
        self.detailTextLabel.numberOfLines = 4;
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _monthLabel = ({
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0.0, 0.0, calendarDateWidth, 1.05 * monthLabelFontSize);;
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor whiteColor];
            label;
        });
        [self.contentView addSubview:_monthLabel];
        
        _dayLabel = ({
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0.0, 0.0, calendarDateWidth, dayLabelFontSize);
            label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:dayLabelFontSize];
            label.textAlignment = NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor whiteColor];
            label;
        });
        [self.contentView addSubview:_dayLabel];
        
        _tagColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.monthLabel.frame = ({
        CGRect frame = self.monthLabel.frame;
        frame.origin.y = 0.5 * (CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(self.monthLabel.bounds) - CGRectGetHeight(self.dayLabel.bounds));
        frame;
    });
    
    self.dayLabel.frame = ({
        CGRect frame = self.dayLabel.frame;
        frame.origin.y = self.monthLabel.frame.origin.y + CGRectGetHeight(self.monthLabel.bounds);
        frame;
    });
    
    self.textLabel.frame = ({
        CGRect frame = self.textLabel.frame;
        frame.origin.x = self.dayLabel.frame.origin.x + CGRectGetWidth(self.dayLabel.bounds) + 4.0;
        frame.size.width = CGRectGetWidth(self.bounds) - self.dayLabel.frame.origin.x - calendarDateWidth - 16.0;
        frame;
    });
    
    self.detailTextLabel.frame = ({
        CGRect frame = self.detailTextLabel.frame;
        frame.origin.x = self.dayLabel.frame.origin.x + CGRectGetWidth(self.dayLabel.bounds) + 4.0;
        frame.size.width = CGRectGetWidth(self.bounds) - self.dayLabel.frame.origin.x - calendarDateWidth - 16.0;
        frame;
    });
}

- (void)setTagColor:(UIColor *)tagColor
{
    _tagColor = (tagColor)? tagColor : [UIColor whiteColor];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_tagColor set];
    CGContextSetLineWidth(context, 4.0);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, 0.0, CGRectGetHeight(self.bounds));
    CGContextStrokePath(context);
}

@end
