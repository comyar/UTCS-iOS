//
//  UTCSDirectoryDetailViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSTableViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>


#pragma mark - Forward Declarations

@class UTCSDirectoryPerson;


#pragma mark - UTCSDirectoryDetailViewController Interface

/**
 UTCSDirectoryDetailViewController is a concrete subclass of UTCSTableViewController that displays
 a single directory person's information.
 */
@interface UTCSDirectoryDetailViewController : UTCSTableViewController <UITableViewDataSource, UIAlertViewDelegate>

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Person whose information to display.
 
 Should be set before presenting this view controller.
 */
@property (nonatomic) UTCSDirectoryPerson *person;

@end
