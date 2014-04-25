//
//  UTCSNavigationController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;


/**
 UTCSNavigationController allows for custom styling of a UINavigationBar throughout the entire
 app without modifying the appearance of the UINavigationBar in classes such as MFMailComposeViewController. 
 UTCSNavigationController provides no extra functionality beyond UINavigationController.
 */
@interface UTCSNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, readonly) UIImageView *backgroundImageView;

@end
