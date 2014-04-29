//
//  UTCSBackgroundBlurHeaderView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSActiveHeaderView.h"


#pragma mark - Constants

//
static const CGFloat animationDuration      = 0.3;

// Font size of the shimmering view
static const CGFloat shimmeringViewFontSize = 50.0;

// Font size of the updated label
static const CGFloat updatedLabelFontSize   = 14.0;

//
static NSString * const shimmeringViewFontName  = @"HelveticaNeue-Bold";

static NSString * const updateLabelFontName     = @"HelveticaNeue";

//
static NSString * const downArrowImageName      = @"downArrow";

#pragma mark - UTCSBackgroundBlurHeaderView Class Extension

@interface UTCSActiveHeaderView ()

// Shimmering view used to indicate loading of news articles
@property (nonatomic) FBShimmeringView                      *shimmeringView;

// Image view used to render the down arrow
@property (nonatomic) UIImageView                           *downArrowImageView;

// Activity indicator used to indicate the news stories are updating
@property (nonatomic) UIActivityIndicatorView               *activityIndicatorView;

// Label used to display the time the news stories were updated
@property (nonatomic) UILabel                               *updatedLabel;

@end


#pragma mark - UTCSBackgroundBlurHeaderView Implementation

@implementation UTCSActiveHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // Shimmering view
        self.shimmeringView = ({
            FBShimmeringView *view = [[FBShimmeringView alloc]initWithFrame:CGRectZero];
            
                view.contentView = ({
                    UILabel *label      = [[UILabel alloc]initWithFrame:CGRectZero];
                    label.font          = [UIFont fontWithName:shimmeringViewFontName size:shimmeringViewFontSize];
                    label.shadowColor   = [UIColor colorWithWhite:0.0 alpha:0.5];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.shadowOffset  = CGSizeMake(0.0, 0.5);
                    label.textColor     = [UIColor whiteColor];
                    label.adjustsFontSizeToFitWidth = YES;
                    label;
                });
            
            view;
        });
        
        // Down arrow image view
        self.downArrowImageView = ({
            UIImage *image = [[UIImage imageNamed:downArrowImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.tintColor = [UIColor whiteColor];
            imageView;
        });
        
        // Activity indicator view
        self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // Updated label
        self.updatedLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:updateLabelFontName size:updatedLabelFontSize];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.alpha = 0.0;
            label;
        });
        
        // Add subviews
        [self addSubview:self.shimmeringView];
        [self addSubview:self.downArrowImageView];
        [self addSubview:self.activityIndicatorView];
        [self addSubview:self.updatedLabel];
    }
    return self;
}

- (void)showActiveAnimation:(BOOL)show
{
    if (show) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }
    
    self.shimmeringView.shimmering = show;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.updatedLabel.alpha = 1.0;
        self.downArrowImageView.alpha = (show)? 0.0 : 1.0;
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Shimmering view
    self.shimmeringView.frame           = CGRectMake(0.0, 0.0, 0.9 * CGRectGetWidth(self.bounds), shimmeringViewFontSize);
    self.shimmeringView.center          = CGPointMake(self.center.x, 0.7 * self.center.y);
    
    // Down arrow image view
    self.downArrowImageView.frame       = CGRectMake(0.0, 0.0, 32, 16);
    self.downArrowImageView.center      = CGPointMake(self.center.x, 1.5 * self.center.y);
    
    // Activity indicator view
    self.activityIndicatorView.center   = CGPointMake(self.center.x, 1.5 * self.center.y);
    
    // Update label
    self.updatedLabel.frame             = CGRectMake(13.0, CGRectGetHeight(self.bounds) - updatedLabelFontSize - 8.0,
                                                     CGRectGetWidth(self.bounds) - 16.0, 1.5 * updatedLabelFontSize);
}

@end
