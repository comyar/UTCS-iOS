//
//  UTCSParallaxBlurHeaderScrollView.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/26/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// Views
#import "UTCSParallaxBlurHeaderScrollView.h"


#pragma mark - Constants

// Factor by which the header translation is slowed down
static const CGFloat parallaxFactor = 0.5;

// Height of the header image
const CGFloat kUTCSParallaxBlurHeaderHeight = 284.0;


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
        
        // Header mask
        self.headerMask = [CAShapeLayer new];
        
        // Header image view
        self.headerImageView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = NO;
            imageView;
        });
        
        // Header blurred image view
        self.headerBlurredImageView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = NO;
            imageView.alpha = 0.0;
            imageView;
        });
        
        // Header container view
        self.headerContainerView = ({
            UIView *view = [UIView new];
            view.layer.masksToBounds = YES;
            view.userInteractionEnabled = NO;
            view;
        });
        
        // Scroll view
        self.scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
            scrollView.alwaysBounceVertical = YES;
            scrollView.delegate = self;
            scrollView;
        });
        
        // Add subviews
        [self addSubview:self.scrollView];
        [self.headerContainerView addSubview:self.headerImageView];
        [self.headerContainerView addSubview:self.headerBlurredImageView];
        [self addSubview:self.headerContainerView];
    }
    return self;
}

#pragma mark Setter Methods

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutIfNeeded];
}

- (void)setHeaderImage:(UIImage *)headerImage
{
    if(headerImage == _headerImage) {
        return;
    }
    
    _headerImage = headerImage;
    self.headerImageView.image = _headerImage;
    [self layoutIfNeeded];
}

- (void)setHeaderBlurredImage:(UIImage *)headerBlurredImage
{
    if(headerBlurredImage == _headerBlurredImage) {
        return;
    }
    
    _headerBlurredImage = headerBlurredImage;
    self.headerBlurredImageView.image = _headerBlurredImage;
    [self layoutIfNeeded];
}

#pragma mark Layout Subviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame               = self.bounds;
    self.headerContainerView.frame      = CGRectMake(0.0, -parallaxFactor * self.scrollView.contentOffset.y,
                                                     CGRectGetWidth(self.bounds), kUTCSParallaxBlurHeaderHeight);
    self.headerImageView.frame          = self.headerContainerView.bounds;
    self.headerBlurredImageView.frame   = self.headerContainerView.bounds;
    self.headerMask.path = [[UIBezierPath bezierPathWithRect:CGRectMake(0.0, parallaxFactor * (CGRectGetHeight(self.headerContainerView.bounds) - 44.0), CGRectGetWidth(self.scrollView.bounds), 44.0)]CGPath];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView) {
        if(scrollView.contentOffset.y > 0) {
            
            if(scrollView.contentOffset.y < CGRectGetHeight(self.headerContainerView.bounds) - 44.0) {
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
                    frame.origin.y = -parallaxFactor * (CGRectGetHeight(self.headerContainerView.bounds) - 44.0);
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
