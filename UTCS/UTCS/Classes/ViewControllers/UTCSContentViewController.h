//
//  UTCSAbstractContentViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;

#import "UTCSDataSource.h"
#import "UTCSMenuButton.h"

/**
 UTCSContentViewController is an abstract class
 */
@interface UTCSContentViewController : UIViewController

// -----
// @name Using a UTCSAbstractContentViewController
// -----

/**
 */
- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion;

// -----
// @name Properties
// -----

/**
 Data source for the view controller
 */
@property (nonatomic) UTCSDataSource        *dataSource;


// Menu button
@property (nonatomic, readonly) UTCSMenuButton *menuButton;


@end
