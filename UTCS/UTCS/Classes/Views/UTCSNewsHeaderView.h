//
//  UTCSNewsHeaderView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

@import UIKit;
@class FBShimmeringView;

#import "UTCSActiveHeaderView.h"


/**
 UTCSNewsHeaderView is the header view of the background blur table view displaying 
 the list of available news stories.
 */
@interface UTCSNewsHeaderView : UTCSActiveHeaderView

/** 
 Label used to display a subtitle beneath the shimmering view
 */
@property (nonatomic, readonly) UILabel *subtitleLabel;

@end
