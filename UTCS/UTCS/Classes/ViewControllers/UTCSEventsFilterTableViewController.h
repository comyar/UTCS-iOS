//
//  UTCSEventsFilterTableViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FXBlurView.h"

@interface UTCSEventsFilterTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) FXBlurView *blurView;

@end
