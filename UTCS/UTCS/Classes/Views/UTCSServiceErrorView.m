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

static NSString * const textPropertyString  = @"text";


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
            [label addObserver:self forKeyPath:textPropertyString options:NSKeyValueObservingOptionNew context:nil];
            label.font = [UIFont fontWithName:errorLabelFontName size:errorLabelFontSize];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.numberOfLines = 4;
            label;
        });
        
        [self addSubview:self.frownyImageView];
        [self addSubview:self.errorLabel];
    }
    return self;
}

#pragma mark Key-Value Observing Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:textPropertyString] && object == self.errorLabel) {
        [self layoutIfNeeded];
    }
}

#pragma mark Setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutIfNeeded];
}

#pragma mark UIView Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frownyImageView.center = CGPointMake(self.center.x, 0.9 * self.center.y);
    
    CGSize errorSize = [self.errorLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds) - 80.0, CGFLOAT_MAX)];
    self.errorLabel.frame = CGRectMake(40.0, self.frownyImageView.frame.origin.y + CGRectGetHeight(self.frownyImageView.bounds) + 28.0,
                                       errorSize.width, errorSize.height);
}

#pragma mark Dealloc

- (void)dealloc
{
    [self.errorLabel removeObserver:self forKeyPath:textPropertyString];
}

@end
