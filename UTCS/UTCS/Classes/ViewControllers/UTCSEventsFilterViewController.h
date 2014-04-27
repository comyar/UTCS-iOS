//
//  UTCSEventsFilterViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSTableViewController.h"

@class UTCSEventsFilterViewController;

@protocol UTCSEventsFilterViewControllerDelegate <NSObject>

- (void)eventsFilterViewController:(UTCSEventsFilterViewController *)eventsFilterViewController
     didRequestDismissalWithFilter:(NSString *)filter;

@end


/**
 */
@interface UTCSEventsFilterViewController : UTCSTableViewController

@end
