//
//  UTCSEventTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSEventTableViewCell.h"


#pragma mark - Constants

// Width of the stripe layer
static const CGFloat typeStripeWidth    = 2.0;


#pragma mark - UTCSEventTableViewCell Implementation

@implementation UTCSEventTableViewCell

#pragma mark Creating a Event Table View Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.numberOfLines        = 4;
        self.detailTextLabel.numberOfLines  = 3;
        
        _typeStripeLayer = ({
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, typeStripeWidth, CGRectGetHeight(self.bounds))].CGPath;
            layer.fillColor     = [UIColor whiteColor].CGColor;
            layer.strokeStart   = 0.0;
            layer.strokeEnd     = 1.0;
            layer;
        });
        [self.layer addSublayer:_typeStripeLayer];
    }
    return self;
}

#pragma mark UIView Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.typeStripeLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, typeStripeWidth, CGRectGetHeight(self.bounds))].CGPath;
}

@end
