//
//  UTCSAbstractContentViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import UIKit;
#import "UTCSDataSource.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"


#pragma mark - UTCSContentViewController Interface

/**
 UTCSContentViewController is an abstract view controller that contains properties shared by many top-level view 
 controllers throughout the app, such as a menu button and a background image view. UTCSContentViewController
 should be used for all services that require an instance of UTCSDataSource to download data.
 */
@interface UTCSContentViewController : UIViewController <UTCSDataSourceDelegate>

// -----
// @name Propertiess
// -----

#pragma mark Properties

/**
 Data source for the view controller. May be nil.
 */
@property (nonatomic) UTCSDataSource            *dataSource;

/**
 Button that shows the menu.
 */
@property (nonatomic, readonly) UIButton        *menuButton;

/**
 Image view for displaying a background image
 */
@property (nonatomic, readonly) UIImageView     *backgroundImageView;

@end
