//
//  UTCSParallaxBlurHeaderScrollView.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/26/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import UIKit;


#pragma mark - Constants

extern const CGFloat kUTCSParallaxBlurHeaderHeight;


#pragma mark - UTCSParallaxBlurHeaderScrollView Interface

/**
 The UTCSParallaxBlurHeaderScrollView class provides support for displaying content that is larger than the size of the
 application's window along with a header displayed at the top. 
 
 A UTCSParallaxBlurHeaderScrollView acts similarly to a UIScrollView, however it should only be used when the content's width
 is no larger than the width of the application window.
 
 The header displays a background image and simulates a dynamic blurring effect by adjusting the opacity of a blurred image 
 as the scroll view's content offset changes. The header may be customized by adding additional subviews to the headerContainerView.
 */
@interface UTCSParallaxBlurHeaderScrollView : UIView

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Image to display in the header.
 */
@property (nonatomic) UIImage                   *headerImage;

/**
 Blurred version of the header image.
 */
@property (nonatomic) UIImage                   *headerBlurredImage;

/**
 Container view for the header. The header may be customized by adding additional subviews to this view.
 */
@property (nonatomic) UIView                    *headerContainerView;

/**
 Scroll view managed by this view.
 */
@property (nonatomic, readonly) UIScrollView    *scrollView;

@end
