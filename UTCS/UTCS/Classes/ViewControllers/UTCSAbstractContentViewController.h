//
//  UTCSAbstractContentViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;

#import "UTCSAbstractDataSource.h"


/**
 */
@interface UTCSAbstractContentViewController : UIViewController

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
@property (nonatomic) UTCSAbstractDataSource        *dataSource;

@end
