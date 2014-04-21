//
//  UTCSNewsHeaderView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// Views
#import "FBShimmeringView.h"
#import "UTCSNewsHeaderView.h"


#pragma mark - Constants

// Font size of the subtitle label
static const CGFloat subtitleLabelFontSize  = 17.0;


#pragma mark - UTCSNewsHeaderView Class Extension

@interface UTCSNewsHeaderView ()

// Label used to display a subtitle beneath the shimmering view
@property (nonatomic) UILabel                               *subtitleLabel;

@end


#pragma mark - UTCSNewsHeaderView Implementation

@implementation UTCSNewsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        ((UILabel *)self.shimmeringView.contentView).text = @"UTCS News";
        
        // Subtitle label
        self.subtitleLabel = ({
            UILabel *label      = [[UILabel alloc]initWithFrame:CGRectZero];
            label.frame         = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1.5 * subtitleLabelFontSize);
            label.font          = [UIFont fontWithName:@"HelveticaNeue" size:subtitleLabelFontSize];
            label.center        = CGPointMake(self.center.x, 0.85 * self.center.y);
            label.text          = @"What Starts Here Changes the World";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor     = [UIColor colorWithWhite:1.0 alpha:0.8];
            label.alpha         = 0.0;
            label;
        });
        
        // Add subviews
        [self addSubview:self.subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Subtitle label
    self.subtitleLabel.frame    = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1.5 * subtitleLabelFontSize);
    self.subtitleLabel.center   = CGPointMake(self.center.x, 0.85 * self.center.y);
}

@end
