//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAppDelegate.h"
#import "UTCSEventsViewController.h"

@interface UTCSAppDelegate ()
@property (strong, nonatomic) UITabBarController *tabBarController;
@end

@implementation UTCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [UITabBarController new];
    self.tabBarController.viewControllers = @[[UTCSEventsViewController new]];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
