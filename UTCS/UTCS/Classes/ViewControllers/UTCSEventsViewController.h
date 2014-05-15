//
//  UTCSEventsViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import UIKit;
#import "UTCSHeaderTableViewController.h"
#import "UTCSStarredEventsViewController.h"


#pragma mark - UTCSEventsViewController Interface

/**
 UTCSEventsViewController is a concrete subclass of UTCSHeaderTableViewController that displays
 all the available UTCS events in a table view. 
 */
@interface UTCSEventsViewController : UTCSHeaderTableViewController <UITableViewDelegate, UTCSDataSourceDelegate, UTCSStarredEventsViewControllerDelegate>

@end
