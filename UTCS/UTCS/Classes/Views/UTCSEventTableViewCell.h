//
//  UTCSEventTableViewCell.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSBouncyTableViewCell.h"


#pragma mark - UTCSEventTableViewCell Interface

/**
 UTCSEventTableViewCell is used by the UTCSEventsViewController and UTCSStarredEventsViewController
 to display basic information regarding an event. It extends UTCSBouncyTableViewCell by adding a 
 thin stripe on the left-hand side of the cell to indicate the event type.
 */
@interface UTCSEventTableViewCell : UTCSBouncyTableViewCell

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Layer located on the left-hand side of the cell to indicate the event type.
 */
@property (nonatomic, readonly) CAShapeLayer    *typeStripeLayer;

@end
