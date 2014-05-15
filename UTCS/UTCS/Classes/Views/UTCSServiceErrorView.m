//
//  UTCSServiceErrorView.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSServiceErrorView.h"


#pragma mark - Constants

//
static NSString * const frownyImageName     = @"frowny";

//
static NSString * const errorLabelFontName  = @"HelveticaNeue-Light";

//
static const CGFloat errorLabelFontSize     = 16.0;


#pragma mark - UTCSServiceErrorView Class Extension

@interface UTCSServiceErrorView ()

//
@property (nonatomic) UIImageView   *frownyImageView;

@end


#pragma mark - UTCSServiceErrorView Implementation

@implementation UTCSServiceErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.frownyImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:frownyImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            imageView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            imageView;
        });
        
        _errorLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:errorLabelFontName size:errorLabelFontSize];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.numberOfLines = 0;
            label.alpha = 0.0;
            label;
        });
        
        [self addSubview:self.frownyImageView];
        [self addSubview:self.errorLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frownyImageView.center = CGPointMake(self.center.x, 0.9 * self.center.y);
    self.errorLabel.frame = CGRectMake(self.frownyImageView.frame.origin.x, self.frownyImageView.frame.origin.y + CGRectGetHeight(self.frownyImageView.bounds), CGRectGetWidth(self.frownyImageView.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.frownyImageView.bounds));
}

@end
