//
//  UTCSTableViewCell.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UTCSTableViewCellBounceDirection) {
    UTCSTableViewCellBounceDirectionUp,
    UTCSTableViewCellBounceDirectionDown
};


@interface UTCSTableViewCell : UITableViewCell

- (void)bounceWithDirection:(UTCSTableViewCellBounceDirection)bounceDirection;

@end
