//
//  UTCSBackgroundBlurHeaderView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import UIKit;
#import "FBShimmeringView.h"


#pragma mark - UTCSActiverHeaderView Interface

/**
 An instance of UTCSActiveHeaderView acts as the header for the table view managed by
 UTCSHeaderTableViewController.
 
 UTCSActiveHeaderView provides a shimmering text view as well as an activity indicator in order
 to indicate activity to the user.
 */
@interface UTCSActiveHeaderView : UIView

// -----
// @name Using a UTCSActiveHeaderView
// -----

#pragma mark Using a UTCSActiveHeaderView

/**
 Starts or stops all activity animations belonging to this view.
 
 @param show    YES if the view should start activity animations
 */
- (void)showActiveAnimation:(BOOL)show;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Shimmering view used to indicate updating.
 
 The content view of the shimmering view is a UILabel. To customize the shimmering
 view, you should update its content view's text.
 */
@property (nonatomic, readonly) FBShimmeringView        *shimmeringView;

/**
 Label used to display a subtitle beneath the shimmering view.
 */
@property (nonatomic) UILabel                           *subtitleLabel;

/**
 Activity indicator used to indicate updating.
 */
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

/**
 Image view used to render the down arrow.
 
 The down arrow is automatically hidden when the activity animations are showing.
 */
@property (nonatomic, readonly) UIImageView             *downArrowImageView;

/**
 Label used to display an update time or date.
 */
@property (nonatomic, readonly) UILabel                 *updatedLabel;

@end
