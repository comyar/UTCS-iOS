//
//  UTCSDiskQuotaAuthenticationViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UTCSDiskQuotaAuthenticationViewControllerDelegate <NSObject>

- (void)didAuthenticate;

@end

@interface UTCSDiskQuotaAuthenticationViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) id<UTCSDiskQuotaAuthenticationViewControllerDelegate> delegate;

@end
