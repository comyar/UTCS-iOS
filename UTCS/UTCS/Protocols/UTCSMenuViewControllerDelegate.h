//
//  UTCSMenuViewControllerDelegate.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


typedef NS_ENUM(NSInteger, UTCSMenuOptions) {
    UTCSMenuOptionNews = 0,
    UTCSMenuOptionEvents,
    UTCSMenuOptionLabs,
    UTCSMenuOptionDirectory,
    UTCSMenuOptionDiskQuota,
    UTCSMenuOptionLogout
};

/**
 */
@protocol UTCSMenuViewControllerDelegate <NSObject>

@optional

/**
 */
- (void)didSelectMenuOption:(UTCSMenuOptions)option;

@end
