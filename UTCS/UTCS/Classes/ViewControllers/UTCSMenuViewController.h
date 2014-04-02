//
//  UTCSMenuViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/18/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTCSMenuViewControllerDelegate.h"




/**
 */
@interface UTCSMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//
@property (weak, nonatomic) id<UTCSMenuViewControllerDelegate> delegate;

@end
