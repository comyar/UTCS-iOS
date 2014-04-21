//
//  UTCSAbstractHeaderTable.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSTableViewController.h"
#import "UTCSActiveHeaderView.h"


/**
 UTCSHeaderTableViewController is an abstract class
 */
@interface UTCSHeaderTableViewController : UTCSTableViewController

// -----
// @name Properties
// -----

/**
 */
@property (nonatomic) UTCSActiveHeaderView      *activeHeaderView;

/**
 */
@property (nonatomic, readonly) UIImageView     *backgroundBlurredImageView;

@end
