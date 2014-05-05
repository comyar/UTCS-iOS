//
//  UTCSBackgroundBlurHeaderView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;

#import "FBShimmeringView.h"


/**
 UTCSActivityHeaderView
 */
@interface UTCSActiveHeaderView : UIView

// -----
// @name Using a UTCSActivityHeaderView
// -----

- (void)showActiveAnimation:(BOOL)show;

// -----
// @name Property
// -----

/**
 Shimmering view used to indicate updating
 
 The content view of the shimmer view is a UILabel
 */
@property (nonatomic, readonly) FBShimmeringView                        *shimmeringView;

/**
 Label used to display a subtitle beneath the shimmering view
 */
@property (nonatomic) UILabel                                           *subtitleLabel;

/**
 Activity indicator used to indicate updating
 */
@property (nonatomic, readonly) UIActivityIndicatorView                 *activityIndicatorView;

/**
 Image view used to render the down arrow
 */
@property (nonatomic, readonly) UIImageView                             *downArrowImageView;

/**
 Label used to display the time the news stories were updated
 */
@property (nonatomic, readonly) UILabel                                 *updatedLabel;

@end
