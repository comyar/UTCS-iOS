//
//  UTCSAbstractTableViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAbstractContentViewController.h"

/**
 */
@interface UTCSAbstractTableViewController : UTCSAbstractContentViewController

// -----
// @name Properties
// -----

/**
 */
@property (nonatomic, readonly) UITableView *tableView;

/**
 */
@property (nonatomic, readonly) UIImageView *backgroundImageView;


@end
