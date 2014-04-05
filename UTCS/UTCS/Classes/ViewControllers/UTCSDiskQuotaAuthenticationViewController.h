//
//  UTCSDiskQuotaAuthenticationViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 */
@protocol UTCSDiskQuotaAuthenticationViewControllerDelegate <NSObject>

/**
 
 */
- (void)didAuthenticate;

@end


/**
 UTCSDiskQuotaAuthenticationViewController allows a user to authenticate with his or her Unix username and password in order
 to view their disk quota. A successful login will result in the username and password being stored by the UTCSAccountManager
 for use throughout the rest of the app.
 */
@interface UTCSDiskQuotaAuthenticationViewController : UIViewController <UITextFieldDelegate>

/**
 
 */
@property (nonatomic) id<UTCSDiskQuotaAuthenticationViewControllerDelegate> delegate;

@end
