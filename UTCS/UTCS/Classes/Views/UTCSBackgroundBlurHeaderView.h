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
 UTCSBackgroundBlurHeaderView 
 */
@interface UTCSBackgroundBlurHeaderView : UIView

/**
 Shimmering view used to indicate loading of news articles
 */
@property (nonatomic, readonly) FBShimmeringView                      *shimmeringView;

/**
 Activity indicator used to indicate the news stories are updating
 */
@property (nonatomic, readonly) UIActivityIndicatorView               *activityIndicatorView;

/**
 Image view used to render the down arrow
 */
@property (nonatomic, readonly) UIImageView                           *downArrowImageView;

/**
 Label used to display the time the news stories were updated
 */
@property (nonatomic, readonly) UILabel                               *updatedLabel;

@end
