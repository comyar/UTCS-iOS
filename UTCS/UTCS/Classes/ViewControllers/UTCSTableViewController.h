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
@interface UTCSTableViewController : UTCSContentViewController <UITableViewDelegate>

// -----
// @name Using a UTCSTableViewController
// -----

#pragma mark Using a UTCSTableViewController

/**
 */
- (instancetype)initWithStyle:(UITableViewStyle)style;

// -----
// @name Properties
// -----

/**
 YES if the navigation bar separator line should be visible
 */
@property (nonatomic) BOOL showsNavigationBarSeparatorLine;

/**
 Table view managed by the table view controller
 */
@property (nonatomic, readonly) UITableView *tableView;

@end
