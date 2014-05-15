//
//  UTCSNewsViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSHeaderTableViewController.h"
#import "UTCSNewsDataSource.h"


#pragma mark - UTCSNewsViewController Interface

/**
 UTCSNewsViewController is a concrete subclass of UTCSHeaderTableViewController that displays
 all the available news articles in a table view. UTCSNewsViewController is also the first
 content view controller presented to the user on application launch.
 */
@interface UTCSNewsViewController : UTCSHeaderTableViewController <UITableViewDelegate, UTCSDataSourceDelegate>

@end
