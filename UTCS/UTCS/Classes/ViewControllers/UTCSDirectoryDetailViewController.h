//
//  UTCSDirectoryDetailViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSTableViewController.h"

@class UTCSDirectoryPerson;

/**
 */
@interface UTCSDirectoryDetailViewController : UTCSTableViewController

@property (nonatomic) UTCSDirectoryPerson *directoryPerson;

@end
