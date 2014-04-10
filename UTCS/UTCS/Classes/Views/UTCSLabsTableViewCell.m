//
//  UTCSLabsTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/9/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsTableViewCell.h"


@implementation UTCSLabsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.textLabel.textColor = [UIColor whiteColor];
        
        self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        
        _occupiedLabel = ({
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), 16);
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            [self addSubview:label];
            label;
        });
        
        
        _indicatorColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(32, self.textLabel.frame.origin.y, CGRectGetWidth(self.textLabel.bounds), CGRectGetHeight(self.textLabel.bounds));
    
    self.occupiedLabel.frame = CGRectMake(32, self.textLabel.frame.origin.y + CGRectGetHeight(self.textLabel.bounds), CGRectGetWidth(self.bounds) - self.detailTextLabel.frame.origin.x, CGRectGetHeight(self.textLabel.bounds));
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = (indicatorColor)? indicatorColor : [UIColor whiteColor];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_indicatorColor set];
    [_indicatorColor setFill];
    
    CGContextSetLineWidth(context, 4.0);
    CGContextAddArc(context, 16, self.textLabel.frame.origin.y + 0.5 * CGRectGetHeight(self.textLabel.bounds), 2.0, 0, 2 * M_PI, 1);
    CGContextStrokePath(context);
}


@end
