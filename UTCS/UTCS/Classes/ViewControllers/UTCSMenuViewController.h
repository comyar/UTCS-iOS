//
//  UTCSMenuViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/18/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

@import UIKit;


typedef NS_ENUM(NSInteger, UTCSMenuOptions) {
    UTCSMenuOptionNews = 0,
    UTCSMenuOptionEvents,
    UTCSMenuOptionLabs,
    UTCSMenuOptionDirectory,
    UTCSMenuOptionDiskQuota,
    UTCSMenuOptionSettings
};

/**
 */
@protocol UTCSMenuViewControllerDelegate <NSObject>

@optional

/**
 */
- (void)didSelectMenuOption:(UTCSMenuOptions)option;

@end



/**
 */
@interface UTCSMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//
@property (weak, nonatomic) id<UTCSMenuViewControllerDelegate> delegate;

@end
