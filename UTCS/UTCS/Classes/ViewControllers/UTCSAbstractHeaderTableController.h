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
@interface UTCSAbstractHeaderTableController : UTCSAbstractTableViewController

// -----
// @name Properties
// -----

/**
 */
@property (nonatomic) UIImage                   *backgroundBlurredImage;

/**
 */
@property (nonatomic) UTCSActivityHeaderView    *activityHeaderView;

@end
