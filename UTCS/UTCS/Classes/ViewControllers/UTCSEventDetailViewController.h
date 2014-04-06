//
//  UTCSEventDetailViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/30/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@class UTCSEvent;

@interface UTCSEventDetailViewController : UIViewController <UITabBarDelegate, EKEventEditViewDelegate>

@property (nonatomic) UTCSEvent *event;

@end
