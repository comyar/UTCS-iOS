//
//  UTCSTableViewCell.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;
#import <POP/POP.h>

typedef NS_ENUM(NSInteger, UTCSBouncyTableViewCellBounceDirection) {
    UTCSBouncyTableViewCellBounceDirectionUp,
    UTCSBouncyTableViewCellBounceDirectionDown
};


@interface UTCSBouncyTableViewCell : UITableViewCell

- (void)bounceWithDirection:(UTCSBouncyTableViewCellBounceDirection)bounceDirection;

@end
