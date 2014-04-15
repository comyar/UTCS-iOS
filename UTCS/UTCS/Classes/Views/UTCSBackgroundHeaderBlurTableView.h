//
//  UTCSHeaderBlurTableView.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

@import UIKit;
@import QuartzCore;

/**
 */
@interface UTCSBackgroundHeaderBlurTableView : UIView <UIGestureRecognizerDelegate>

/**
 View to display as the table view's header
 */
@property (nonatomic, readonly) UIView          *header;

/**
 Table view to display feed or list
 */
@property (nonatomic, readonly) UITableView     *tableView;

/**
 Image to display behind the table view
 */
@property (nonatomic) UIImage                   *backgroundImage;

/**
 Blurred image to display behind the table view as the user scrolls
 */
@property (nonatomic) UIImage                   *backgroundBlurredImage;

@end
