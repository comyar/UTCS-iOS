//
//  UTCSDirectoryViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSTableViewController.h"


#pragma mark - UTCSDirectoryViewController Interface

/**
 UTCSDirectoryViewController is a concrete subclass of UTCSTableViewController that displays
 all the available persons in the UTCS directory in a table view.
 */
@interface UTCSDirectoryViewController : UTCSTableViewController <UISearchDisplayDelegate, UTCSDataSourceDelegate>

@end
