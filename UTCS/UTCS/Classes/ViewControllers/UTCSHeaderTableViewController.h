//
//  UTCSAbstractHeaderTable.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

#import "UTCSTableViewController.h"
#import "UTCSActiveHeaderView.h"


#pragma mark - UTCSHeaderTableViewController Interface

/**
 UTCSHeaderTableViewController is an abstract view controller that extends the functionality of UTCSTableViewController
 by managing its own header. UTCSHeaderTableViewController also provides an additional image view intended to add a 
 seemingly-dynamic blurring effect.
 */
@interface UTCSHeaderTableViewController : UTCSTableViewController

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Header view of the table view. 
 
 The bounds of the header view should match those of the table view.
 */
@property (nonatomic) UTCSActiveHeaderView      *activeHeaderView;

/**
 Image view intended to display a blurred version of the  view controller's background image. 
 The alpha of the image view is increased as the table view's content offset increases.
 */
@property (nonatomic, readonly) UIImageView     *backgroundBlurredImageView;

@end
