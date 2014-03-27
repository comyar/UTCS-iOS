//
//  UTCSParallaxBlurHeaderScrollView.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/26/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSParallaxBlurHeaderScrollView.h"


const CGFloat parallaxFactor        = 0.5;
const CGFloat navigationBarHeight   = 64.0;


#pragma mark - UTCSNewsDetailView Class Extension

@interface UTCSParallaxBlurHeaderScrollView ()

/**
 */
@property (nonatomic) UIImageView   *headerImageView;

/**
 */
@property (nonatomic) UIImageView   *headerBlurredImageView;

/**
 */
@property (nonatomic) UIScrollView  *scrollView;

@property (nonatomic) CAShapeLayer  *headerMask;

@end


#pragma mark - UTCSNewsDetailView Implementation

@implementation UTCSParallaxBlurHeaderScrollView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.headerMask                             = [CAShapeLayer new];
        
        self.headerImageView                        = [UIImageView new];
        self.headerImageView.tintColor              = [UIColor colorWithWhite:0.11 alpha:0.73];
        self.headerImageView.contentMode            = UIViewContentModeScaleAspectFill;
        self.headerImageView.userInteractionEnabled = NO;
        
        self.headerBlurredImageView                 = [UIImageView new];
        self.headerBlurredImageView.tintColor       = [UIColor colorWithWhite:0.11 alpha:0.73];
        self.headerBlurredImageView.alpha           = 0.0;
        self.headerBlurredImageView.contentMode     = UIViewContentModeScaleAspectFill;
        self.headerBlurredImageView.userInteractionEnabled = NO;
        
        self.headerContainerView                    = [UIView new];
        self.headerContainerView.layer.masksToBounds    = YES;
        self.headerContainerView.userInteractionEnabled = NO;
        
        [self.headerContainerView addSubview:self.headerImageView];
        [self.headerContainerView addSubview:self.headerBlurredImageView];
        [self addSubview:self.headerContainerView];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
    }
    return self;
}

#pragma mark Layout Subviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headerContainerView.frame      = CGRectMake(0.0, -parallaxFactor * self.scrollView.contentOffset.y,
                                                     CGRectGetWidth(self.bounds), _headerImage.size.height);
    self.headerImageView.frame          = self.headerContainerView.bounds;
    self.headerBlurredImageView.frame   = self.headerContainerView.bounds;
}


#pragma mark Setter Methods

- (void)setHeaderImage:(UIImage *)headerImage
{
    if(headerImage == _headerImage) {
        return;
    }
    
    _headerImage = headerImage;
    self.headerImageView.image = _headerImage;
    [self setNeedsDisplay];
}

- (void)setHeaderBlurredImage:(UIImage *)headerBlurredImage
{
    if(headerBlurredImage == _headerBlurredImage) {
        return;
    }
    
    _headerBlurredImage = headerBlurredImage;
    self.headerBlurredImageView.image = _headerBlurredImage;
    [self setNeedsDisplay];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView) {
        if(scrollView.contentOffset.y > 0) {
            if(scrollView.contentOffset.y < CGRectGetHeight(self.headerContainerView.bounds) - navigationBarHeight) {
                self.headerContainerView.frame = ({
                    CGRect frame = self.headerContainerView.frame;
                    frame.origin.y = -parallaxFactor * scrollView.contentOffset.y;
                    frame;
                });
                [self bringSubviewToFront:self.scrollView];
            } else {
                [self bringSubviewToFront:self.headerContainerView];
            }
        } else {
            self.headerContainerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.headerContainerView.bounds), CGRectGetHeight(self.headerContainerView.bounds));
            [self bringSubviewToFront:self.scrollView];
        }
        
        self.headerBlurredImageView.alpha = MIN(1.0, 4.0 * MAX(scrollView.contentOffset.y / CGRectGetHeight(self.bounds), 0.0));
    }
}

@end
