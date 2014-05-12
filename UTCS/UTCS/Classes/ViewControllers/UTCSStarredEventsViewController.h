//
//  UTCSEventsStarListViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSTableViewController.h"

@class UTCSEvent;
@class UTCSStarredEventsViewController;

@protocol UTCSStarredEventsViewControllerDelegate <NSObject>

@optional
- (void)starredEventsViewController:(UTCSStarredEventsViewController *)starredEventsViewController
                     didSelectEvent:(UTCSEvent *)event;

@end

@interface UTCSStarredEventsViewController : UTCSTableViewController

@property (nonatomic) id<UTCSStarredEventsViewControllerDelegate> delegate;

@end
