//
//  UTCSNewsViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;
@import QuartzCore;


/**
 UTCSNewsViewController displays all the available news articles in a simple table
 */
@interface UTCSNewsViewController : UIViewController <UITableViewDelegate>

// -----
// @name Updating
// -----

/**
 Updates the news data source
 */
- (void)update;

@end
