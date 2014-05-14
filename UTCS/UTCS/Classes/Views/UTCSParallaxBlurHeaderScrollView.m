//
//  UTCSParallaxBlurHeaderScrollView.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/26/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSParallaxBlurHeaderScrollView.h"


#pragma mark - Constants

// Factor by which the header translation is slowed down
static const CGFloat parallaxFactor         = 0.5;

// Height of the header image
const CGFloat kUTCSParallaxBlurHeaderHeight = 284.0;

//
static const CGFloat blurAlphaModifier      = 2.5;

static const CGFloat navigationBarHeight    = 44.0;

// Content offset property string used for KVO
static NSString * const contentOffsetPropertyString         = @"contentOffset";
static NSString * const framePropertyString                 = @"frame";


#pragma mark - UTCSNewsDetailView Class Extension

@interface UTCSParallaxBlurHeaderScrollView ()

//
@property (nonatomic) CAShapeLayer  *headerMask;

// Scroll view managed by this view.
@property (nonatomic) UIScrollView  *scrollView;

//
@property (nonatomic) UIImageView   *headerImageView;

//
@property (nonatomic) UIImageView   *headerBlurredImageView;

@end


#pragma mark - UTCSNewsDetailView Implementation

@implementation UTCSParallaxBlurHeaderScrollView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.headerMask = [CAShapeLayer new];
        
        self.headerImageView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = NO;
            imageView;
        });
        
        self.headerBlurredImageView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = NO;
            imageView.alpha = 0.0;
            imageView;
        });
        
        self.headerContainerView = ({
            UIView *view = [UIView new];
            [view addObserver:self forKeyPath:framePropertyString options:NSKeyValueObservingOptionNew context:nil];
            view.userInteractionEnabled = NO;
            view.layer.masksToBounds    = YES;
            view;
        });
        
        self.scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
            [scrollView addObserver:self forKeyPath:contentOffsetPropertyString options:NSKeyValueObservingOptionNew context:nil];
            scrollView.alwaysBounceVertical = YES;
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
    self.scrollView.frame = self.bounds;
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
    self.headerContainerView.frame      = CGRectMake(0.0, -parallaxFactor * self.scrollView.contentOffset.y,
                                                     CGRectGetWidth(self.bounds), kUTCSParallaxBlurHeaderHeight);
    self.headerImageView.frame          = self.headerContainerView.bounds;
    self.headerBlurredImageView.frame   = self.headerContainerView.bounds;
    self.headerMask.path = [[UIBezierPath bezierPathWithRect:CGRectMake(0.0, parallaxFactor * (CGRectGetHeight(self.headerContainerView.bounds) - navigationBarHeight), CGRectGetWidth(self.scrollView.bounds), navigationBarHeight)]CGPath];
}

#pragma mark Key-Value Observing Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:contentOffsetPropertyString] && object == self.scrollView) {
        CGFloat contentOffset = self.scrollView.contentOffset.y;
        
        if (contentOffset > 0.0 && contentOffset < CGRectGetHeight(self.headerContainerView.bounds) - navigationBarHeight) {
            self.headerContainerView.frame = ({
                CGRect frame = self.headerContainerView.frame;
                frame.origin.y = -parallaxFactor * contentOffset;
                frame;
            });
            self.headerContainerView.layer.mask = nil;
            [self bringSubviewToFront:self.scrollView];
        } else {
            [self bringSubviewToFront:self.headerContainerView];
        }
        
        if (contentOffset >= CGRectGetHeight(self.headerContainerView.bounds) - navigationBarHeight) {
            self.headerContainerView.layer.mask = self.headerMask;
        } else {
            self.headerContainerView.layer.mask = nil;
        }
        
        self.headerBlurredImageView.alpha = MIN(1.0, blurAlphaModifier * MAX(self.scrollView.contentOffset.y /
                                                                             CGRectGetHeight(self.bounds), 0.0));
        for(UIView *subview in self.headerContainerView.subviews) {
            if(subview != self.headerBlurredImageView && subview != self.headerImageView) {
                subview.alpha = MAX(0.0, 1.0 - self.headerBlurredImageView.alpha);
            }
        }
    } else if ([keyPath isEqualToString:framePropertyString] && object == self.headerContainerView) {
        if (self.headerContainerView.frame.origin.y > 0.0) {
            self.headerContainerView.frame = ({
                CGRect frame = self.headerContainerView.frame;
                frame.origin.y = 0.0;
                frame;
            });
        }
    }
}

@end
