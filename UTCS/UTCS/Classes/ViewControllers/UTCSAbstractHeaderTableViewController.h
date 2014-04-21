//
//  UTCSAbstractHeaderTable.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAbstractTableViewController.h"

@class UTCSActivityHeaderView;


/**
 */
@interface UTCSAbstractHeaderTableViewController : UTCSAbstractTableViewController

// -----
// @name Properties
// -----

/**
 */
@property (nonatomic) UTCSActivityHeaderView    *activityHeaderView;

/**
 */
@property (nonatomic, readonly) UIImageView     *backgroundBlurredImageView;

@end
