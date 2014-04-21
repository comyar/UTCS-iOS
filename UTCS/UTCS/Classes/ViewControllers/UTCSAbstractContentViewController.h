//
//  UTCSAbstractContentViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;

@class UTCSAbstractDataSource;


/**
 */
@interface UTCSAbstractContentViewController : UIViewController

// -----
// @name Using a UTCSAbstractContentViewController
// -----

/**
 */
- (void)updateWithArgument:(NSString *)argument;

// -----
// @name Properties
// -----

/**
 Data source for the view controller
 */
@property (nonatomic) UTCSAbstractDataSource        *dataSource;

@end
