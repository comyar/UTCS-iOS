//
//  UTCSEventsViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "UTCSEventsFilterTableViewController.h"

@interface UTCSEventsViewController : UIViewController <UITableViewDelegate, WYPopoverControllerDelegate, UTCSEventsFilterTableViewControllerDelegate>

@end
