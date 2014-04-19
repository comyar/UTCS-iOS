//
//  UTCSEventsViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

@import UIKit;

#import "WYPopoverController.h"
#import "UTCSEventsFilterTableViewController.h"


/**
 UTCSEventsViewController displays all the available events in a simple table and allows filtering of events by type
 */
@interface UTCSEventsViewController : UIViewController <UITableViewDelegate, WYPopoverControllerDelegate, UTCSEventsFilterTableViewControllerDelegate>

// -----
// @name Updating
// -----

/**
 Updates the news data source
 */
- (void)update;

@end
