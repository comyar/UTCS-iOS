//
//  UTCSEventDetailViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class UTCSEvent;

@interface UTCSEventDetailViewController : UIViewController

@property (strong, nonatomic) UTCSEvent *event;

@end
