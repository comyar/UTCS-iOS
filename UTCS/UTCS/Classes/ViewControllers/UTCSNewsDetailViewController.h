//
//  UTCSNewsDetailViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTCSVerticalMenuViewController.h"

@class UTCSNewsStory;

@interface UTCSNewsDetailViewController : UIViewController <UTCSVerticalMenuViewControllerDelegate>

@property (strong, nonatomic) UTCSNewsStory *newsStory;

@end
