//
//  UTCSNewsHeaderView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBShimmeringView;

@interface UTCSNewsHeaderView : UIView

// Label used to display the time the news stories were updated
@property (nonatomic, readonly) UILabel                               *updatedLabel;

// Label used to display a subtitle beneath the shimmering view
@property (nonatomic, readonly) UILabel                               *subtitleLabel;

// Image view used to render the down arrow
@property (nonatomic, readonly) UIImageView                           *downArrowImageView;

// Activity indicator used to indicate the news stories are updating
@property (nonatomic, readonly) UIActivityIndicatorView               *activityIndicatorView;

// Shimmering view used to indicate loading of news articles
@property (nonatomic, readonly) FBShimmeringView                      *shimmeringView;

@end
