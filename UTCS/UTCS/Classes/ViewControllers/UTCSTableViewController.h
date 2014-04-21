//
//  UTCSAbstractTableViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSContentViewController.h"

/**
 UTCSTableViewController is an abstract class
 */
@interface UTCSTableViewController : UTCSContentViewController

// -----
// @name Properties
// -----

/**
 */
@property (nonatomic) BOOL showsNavigationBarSeparatorLine;

/**
 */
@property (nonatomic, readonly) UITableView *tableView;

/**
 */
@property (nonatomic, readonly) UIImageView *backgroundImageView;


@end
