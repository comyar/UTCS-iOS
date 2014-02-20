//
//  UTCSMenuViewControllerDelegate.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


/**
 */
@protocol UTCSMenuViewControllerDelegate <NSObject>

@optional

/**
 */
- (void)didSelectMenuOption:(UTCSMenuOptions)option;

@end
