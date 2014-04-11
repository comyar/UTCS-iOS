//
//  UTCSMenuButton.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSMenuButton.h"
#import "UTCSVerticalMenuViewController.h"

static const CGFloat goldenRatio = 1.618;


@implementation UTCSMenuButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.tag = NSIntegerMax;
        self.lineColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)didTouchUpInside
{
    [super didTouchUpInside];
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:UTCSVerticalMenuDisplayNotification
                                                                                        object:self]];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat lineWidth = CGRectGetHeight(self.bounds) / (20.0 * goldenRatio);
    CGContextSetLineWidth(context, lineWidth);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
    
    CGContextMoveToPoint(context, 0.25 * CGRectGetWidth(self.bounds), 0.25 * CGRectGetHeight(self.bounds));
    CGContextAddLineToPoint(context, 0.75 * CGRectGetWidth(self.bounds), 0.25 * CGRectGetHeight(self.bounds));
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0.25 * CGRectGetWidth(self.bounds), 0.5 * CGRectGetHeight(self.bounds) - 0.5 * lineWidth);
    CGContextAddLineToPoint(context, 0.75 * CGRectGetWidth(self.bounds), 0.5 * CGRectGetHeight(self.bounds) - 0.5 * lineWidth);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0.25 * CGRectGetWidth(self.bounds), 0.75 * CGRectGetHeight(self.bounds) - lineWidth);
    CGContextAddLineToPoint(context, 0.75 * CGRectGetWidth(self.bounds), 0.75 * CGRectGetHeight(self.bounds) - lineWidth);
    CGContextStrokePath(context);
    
    CGColorSpaceRelease(colorspace);
}

@end
