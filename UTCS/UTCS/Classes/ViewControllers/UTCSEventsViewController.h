//
//  UTCSEventsViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

@import UIKit;

#import "UTCSHeaderTableViewController.h"
#import "IBActionSheet.h"

/**
 UTCSEventsViewController displays all the available events in a simple table and allows filtering of events by type
 */
@interface UTCSEventsViewController : UTCSHeaderTableViewController <UITableViewDelegate, IBActionSheetDelegate>


@end
