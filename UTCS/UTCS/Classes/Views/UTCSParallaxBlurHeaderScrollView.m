//
//  UTCSParallaxBlurHeaderScrollView.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/26/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSParallaxBlurHeaderScrollView.h"

//
static const CGFloat parallaxFactor        = 0.5;

//
static const CGFloat navigationBarHeight   = 44.0;


#pragma mark - UTCSNewsDetailView Class Extension

@interface UTCSParallaxBlurHeaderScrollView ()

//
@property (nonatomic) UIImageView   *headerImageView;

//
@property (nonatomic) UIImageView   *headerBlurredImageView;

//
@property (nonatomic) UIScrollView  *scrollView;

//
@property (nonatomic) CAShapeLayer  *headerMask;

@end


#pragma mark - UTCSNewsDetailView Implementation

@implementation UTCSParallaxBlurHeaderScrollView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _navigationBarHeight = navigationBarHeight;
        
        self.headerImageView                        = [UIImageView new];
        self.headerImageView.contentMode            = UIViewContentModeScaleAspectFill;
        self.headerImageView.userInteractionEnabled = NO;
        
        self.headerBlurredImageView                 = [UIImageView new];
        self.headerBlurredImageView.alpha           = 0.0;
        self.headerBlurredImageView.contentMode     = UIViewContentModeScaleAspectFill;
        self.headerBlurredImageView.userInteractionEnabled = NO;
        
        self.headerContainerView                        = [UIView new];
        self.headerContainerView.layer.masksToBounds    = YES;
        self.headerContainerView.userInteractionEnabled = NO;
        
        [self.headerContainerView addSubview:self.headerImageView];
        [self.headerContainerView addSubview:self.headerBlurredImageView];
        [self addSubview:self.headerContainerView];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.headerMask = [CAShapeLayer new];
        
    }
    return self;
}

#pragma mark Setter Methods

- (void)setHeaderImage:(UIImage *)headerImage
{
    if(headerImage == _headerImage) {
        return;
    }
    
    _headerImage = headerImage;
    self.headerImageView.image = _headerImage;
    [self updateSubviews];
}

- (void)setHeaderBlurredImage:(UIImage *)headerBlurredImage
{
    if(headerBlurredImage == _headerBlurredImage) {
        return;
    }
    
    _headerBlurredImage = headerBlurredImage;
    self.headerBlurredImageView.image = _headerBlurredImage;
    [self updateSubviews];
}

#pragma mark Layout Subviews

- (void)updateSubviews
{
    [super layoutSubviews];
    self.headerContainerView.frame      = CGRectMake(0.0, -parallaxFactor * self.scrollView.contentOffset.y,
                                                     CGRectGetWidth(self.bounds), _headerImage.size.height);
    self.headerImageView.frame          = self.headerContainerView.bounds;
    self.headerBlurredImageView.frame   = self.headerContainerView.bounds;
    self.headerMask.path = [[UIBezierPath bezierPathWithRect:CGRectMake(0.0, parallaxFactor * (CGRectGetHeight(self.headerContainerView.bounds) - navigationBarHeight), CGRectGetWidth(self.scrollView.bounds), navigationBarHeight)]CGPath];
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
                self.headerContainerView.layer.mask = nil;
                [self bringSubviewToFront:self.scrollView];
            } else {
                self.headerContainerView.frame = ({
                    CGRect frame = self.headerContainerView.frame;
                    frame.origin.y = -parallaxFactor * (CGRectGetHeight(self.headerContainerView.bounds) - navigationBarHeight);
                    frame;
                });
                self.headerContainerView.layer.mask = self.headerMask;
                [self bringSubviewToFront:self.headerContainerView];
            }
        } else {
            self.headerContainerView.frame = ({
                CGRect frame = self.headerContainerView.frame;
                frame.origin.y = 0.0;
                frame;
            });
            self.headerContainerView.layer.mask = nil;
            [self bringSubviewToFront:self.headerContainerView];
        }
        
        self.headerBlurredImageView.alpha = MIN(1.0, 4.0 * MAX(scrollView.contentOffset.y / CGRectGetHeight(self.bounds), 0.0));
        for(UIView *subview in self.headerContainerView.subviews) {
            if(subview != self.headerBlurredImageView && subview != self.headerImageView) {
                subview.alpha = 1.0 - MIN(1.0, 2.5 * MAX(scrollView.contentOffset.y / CGRectGetHeight(self.bounds), 0.0));
            }
        }
    }
}

@end
