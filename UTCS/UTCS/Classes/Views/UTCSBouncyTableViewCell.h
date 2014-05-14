//
//  UTCSTableViewCell.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import UIKit;
#import <POP/POP.h>


#pragma mark - Typedefs

/**
 UTCSBouncyTableViewCell bounce directions.
 */
typedef NS_ENUM(int8_t, UTCSBouncyTableViewCellBounceDirection) {
    /** Bounce upwards (i.e. scale up). */
    UTCSBouncyTableViewCellBounceDirectionUp,
    
    /** Bounce downwards (i.e. scale down). */
    UTCSBouncyTableViewCellBounceDirectionDown
};


#pragma mark - UTCSBouncyTableViewCell Interface

/**
 UTCSBouncyTableViewCell is a subclass of UITableViewCell that allows the content view
 of a cell to 'bounce'. The content view of a cell will bounce when the setHighlighted:animated:
 selector is performed with YES as the animated argument. The content view of a cell may also be bounced
 by explicitly calling bounceWithDirection:. The alpha of the cell's content view will also animate based on 
 the direction of the bounce.
 
 UTCSBouncyTableViewCell incorporates the Facebook POP animation library to perform smooth physics-based animations.
 */
@interface UTCSBouncyTableViewCell : UITableViewCell <POPAnimationDelegate>

// -----
// @name Using a UTCSBouncyTableViewCell
// -----

#pragma mark Using a UTCSBouncyTableViewCell

/**
 Bounces the content view of a cell in the given direction
 @param bounceDirection     Direction to bounce the content view
 */
- (void)bounceWithDirection:(UTCSBouncyTableViewCellBounceDirection)bounceDirection;

@end
