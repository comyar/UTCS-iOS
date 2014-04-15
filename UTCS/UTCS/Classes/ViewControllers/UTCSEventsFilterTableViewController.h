//
//  UTCSEventsFilterTableViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UTCSEventsFilterTableViewController;

@protocol UTCSEventsFilterTableViewControllerDelegate <NSObject>

- (void)eventsFilterTableViewController:(UTCSEventsFilterTableViewController *)eventsFilterTableViewController didSelectFilter:(NSString *)filter;

@end

@interface UTCSEventsFilterTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) id<UTCSEventsFilterTableViewControllerDelegate> delegate;

@end
