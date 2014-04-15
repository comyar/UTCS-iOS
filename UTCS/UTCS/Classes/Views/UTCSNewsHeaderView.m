//
//  UTCSNewsHeaderView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSNewsHeaderView.h"
#import "FBShimmeringView.h"


#pragma mark - Constants

// Font size of the shimmering view
static const CGFloat shimmeringViewFontSize = 50.0;

// Font size of the subtitle label
static const CGFloat subtitleLabelFontSize  = 17.0;

// Font size of the updated label
static const CGFloat updatedLabelFontSize   = 14.0;


#pragma mark - UTCSNewsHeaderView Class Extension

@interface UTCSNewsHeaderView ()

// Label used to display the time the news stories were updated
@property (nonatomic) UILabel                               *updatedLabel;

// Label used to display a subtitle beneath the shimmering view
@property (nonatomic) UILabel                               *subtitleLabel;

// Image view used to render the down arrow
@property (nonatomic) UIImageView                           *downArrowImageView;

// Activity indicator used to indicate the news stories are updating
@property (nonatomic) UIActivityIndicatorView               *activityIndicatorView;

// Shimmering view used to indicate loading of news articles
@property (nonatomic) FBShimmeringView                      *shimmeringView;

@end


#pragma mark - UTCSNewsHeaderView Implementation

@implementation UTCSNewsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // Shimmering view
        self.shimmeringView = ({
            FBShimmeringView *view = [[FBShimmeringView alloc]initWithFrame:CGRectZero];
            
                view.contentView = ({
                    UILabel *label      = [[UILabel alloc]initWithFrame:view.bounds];
                    label.font          = [UIFont fontWithName:@"HelveticaNeue-Bold" size:shimmeringViewFontSize];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor     = [UIColor whiteColor];
                    label.text          = @"UTCS News";
                    label;
                });
            
            view;
        });
        
        // Subtitle label
        self.subtitleLabel = ({
            UILabel *label      = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font          = [UIFont fontWithName:@"HelveticaNeue" size:subtitleLabelFontSize];
            label.text          = @"What Starts Here Changes the World";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor     = [UIColor colorWithWhite:1.0 alpha:0.8];
            label.alpha         = 0.0;
            label;
        });
        
        // Down arrow image view
        self.downArrowImageView = ({
            UIImage *image = [[UIImage imageNamed:@"downArrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.tintColor = [UIColor whiteColor];
            imageView.alpha = 0.0;
            imageView;
        });
        
        // Activity indicator view
        self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // Updated label
        self.updatedLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:updatedLabelFontSize];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.alpha = 0.0;
            [self addSubview:label];
            label;
        });
        
        [self addSubview:self.shimmeringView];
        [self addSubview:self.subtitleLabel];
        [self addSubview:self.downArrowImageView];
        [self addSubview:self.activityIndicatorView];
        [self addSubview:self.updatedLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.shimmeringView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), shimmeringViewFontSize);
    self.shimmeringView.center = CGPointMake(self.center.x, 0.7 * self.center.y);
    
    self.subtitleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1.5 * subtitleLabelFontSize);
    self.subtitleLabel.center = CGPointMake(self.center.x, 0.85 * self.center.y);
    
    self.downArrowImageView.frame = CGRectMake(0.0, 0.0, 32, 16);
    self.downArrowImageView.center = CGPointMake(self.center.x, 1.5 * self.center.y);
    
    
    self.activityIndicatorView.center = CGPointMake(self.center.x, 1.5 * self.center.y);
    
    self.updatedLabel.frame = CGRectMake(13.0, CGRectGetHeight(self.bounds) - 44.0 - updatedLabelFontSize - 8.0,
                                         CGRectGetWidth(self.bounds) - 16.0, 1.5 * updatedLabelFontSize);
}

@end
