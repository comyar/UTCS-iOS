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
 UTCSContentViewController is an abstract view controller used for services that require a data source. 
 Every UTCSContentViewController has a menu button and an image view to display a background image.
 
 For each service, you should subclass UTCSContentViewController and configure it with the appropriate data
 source. A UTCSContentViewController should only be used when a particular feature requires an instance of
 UTCSDataSource to download data.
 */
@interface UTCSContentViewController : UIViewController <UTCSDataSourceDelegate>

// -----
// @name Propertiess
// -----

#pragma mark Properties

/**
 Data source for the view controller.
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
