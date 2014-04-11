//
//  UTCSWebViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import <UIKit/UIKit.h>


@class UTCSWebViewController;


/**
 */
@protocol UTCSWebViewControllerDelegate <NSObject>

@required

/**
 */
- (void)webViewControllerDidRequestDismissal:(UTCSWebViewController *)webViewController;

@end


/**
 */
@interface UTCSWebViewController : UIViewController <NSURLConnectionDataDelegate>

/**
 */
@property (nonatomic) NSURL *url;

/**
 */
@property (nonatomic) id<UTCSWebViewControllerDelegate> delegate;

@end
