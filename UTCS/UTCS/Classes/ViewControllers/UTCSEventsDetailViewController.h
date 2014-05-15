//
//  UTCSEventDetailViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/30/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import UIKit;
@import EventKit;

#pragma mark - Forward Declarations

@class UTCSEvent;


#pragma mark - UTCSEventsDetailViewController Interface

/**
 UTCSEventsDetailViewController is a concrete subclass of UIViewController that displays
 a single UTCS event.
 */
@interface UTCSEventsDetailViewController : UIViewController <UITabBarDelegate, UIAlertViewDelegate>

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Event to display.
 
 Should be set before presenting this view controller.
 */
@property (nonatomic) UTCSEvent *event;

@end
