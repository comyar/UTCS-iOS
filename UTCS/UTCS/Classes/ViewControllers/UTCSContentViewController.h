//
//  UTCSAbstractContentViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;

#import "UTCSDataSource.h"
#import "UIView+CZPositioning.h"
#import "UIColor+UTCSColors.h"

/**
 UTCSContentViewController is an abstract class
 */
@interface UTCSContentViewController : UIViewController <UTCSDataSourceDelegate>

// -----
// @name Using a UTCSAbstractContentViewController
// -----

/**
 */
- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion;

// -----
// @name Propertiess
// -----

/**
 Data source for the view controller
 */
@property (nonatomic) UTCSDataSource            *dataSource;

/**
 Menu button
 */
@property (nonatomic, readonly) UIButton        *menuButton;

/**
 */
@property (nonatomic, readonly) UIImageView     *backgroundImageView;


@end
