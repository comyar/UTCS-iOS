//
//  UTCSApplication.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Block to execute when attempting to redirect to Safari
 */
typedef BOOL (^UTCSApplicationURLHandler)(NSURL *url);

@interface UTCSApplication : UIApplication

/**
 URL handler block to execute when the URL touched by the user is a web address
 */
@property (strong, nonatomic) UTCSApplicationURLHandler urlHandler;

@end
