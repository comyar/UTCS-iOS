//
//  UTCSParallaxBlurHeaderScrollView.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/26/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;


/**
 UTCSParallaxBlurHeaderScrollView
 */
@interface UTCSParallaxBlurHeaderScrollView : UIView <UIScrollViewDelegate>

/**
 */
@property (nonatomic) UIImage       *headerImage;

/**
 */
@property (nonatomic) UIImage       *headerBlurredImage;

/**
 */
@property (nonatomic) UIView        *headerContainerView;

/**
 */
@property (nonatomic, readonly) UIScrollView *scrollView;

@end
