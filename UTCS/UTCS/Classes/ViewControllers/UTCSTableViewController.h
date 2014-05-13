//
//  UTCSAbstractTableViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSContentViewController.h"


#pragma mark - UTCSTableViewController Interface

/**
 UTCSTableViewController is an abstract view controller for displaying data in a basic table view. UTCSTableViewController 
 provides an artificial navigation bar above its table view.
 */
@interface UTCSTableViewController : UTCSContentViewController <UITableViewDelegate>

// -----
// @name Using a UTCSTableViewController
// -----

#pragma mark Using a UTCSTableViewController

/**
 Designated initializer. Initializes a new instance of UTCSTableViewController.
 
 @param style   Style of the table view. Default style is UITableViewStylePlain.
 @return Newly initialized UTCSTableViewController instance
 */
- (instancetype)initWithStyle:(UITableViewStyle)style;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Table view managed by the table view controller.
 */
@property (nonatomic, readonly) UITableView *tableView;

/**
 YES if the navigation bar separator line should be visible.
 
 The alpha value of the separator line depends on the content offset
 of the table view. Default is YES.
 */
@property (nonatomic) BOOL showsNavigationBarSeparatorLine;

@end
