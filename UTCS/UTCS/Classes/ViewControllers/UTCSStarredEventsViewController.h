//
//  UTCSEventsStarListViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports


#pragma mark - Forward Declarations

@class UTCSEvent;
@class UTCSStarredEventsViewController;


#pragma mark - UTCSStarredEventsViewControllerDelegate Protocol

/**
 The delegate of UTCSStarredEventsViewController must adopt the UTCSStarredEventsViewControllerDelegate protocol. Optional methods
 allow the delegate to respond to user actions while the UTCSStarredEventsViewController is presented.
 */
@protocol UTCSStarredEventsViewControllerDelegate <NSObject>

@optional

/**
 Tells the delegate the user selected a particular starred event.
 @param starredEventsViewController     Starred events view controller object informing the delegate.
 @param event                           Event selected by the user.
 */
- (void)starredEventsViewController:(UTCSStarredEventsViewController *)starredEventsViewController
                     didSelectEvent:(UTCSEvent *)event;

@end


#pragma mark - UTCSStarredEventsViewController Interface

/**
 UTCSStarredEventsViewController is a concrete subclass of UTCSTableViewController that displays
 all the starred UTCS events in a table view.
 */
@interface UTCSStarredEventsViewController : UTCSTableViewController

/**
 The object that acts as the delegate of the starred events view controller.
 */
@property (nonatomic) id<UTCSStarredEventsViewControllerDelegate> delegate;

@end
