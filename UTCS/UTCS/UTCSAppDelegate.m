//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAppDelegate.h"
#import "UTCSEventsViewController.h"
#import "UTCSLabsViewController.h"
#import "UTCSDirectoryViewController.h"
#import "UTCSMoreViewController.h"

@interface UTCSAppDelegate ()
@property (strong, nonatomic) UITabBarController        *tabBarController;
@property (strong, nonatomic) UINavigationController    *eventsNavigationController;
@end

@implementation UTCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [UITabBarController new];
    self.eventsNavigationController = [[UINavigationController alloc]initWithRootViewController:[UTCSEventsViewController new]];
    self.tabBarController.viewControllers = @[self.eventsNavigationController,
                                              [UTCSLabsViewController new],
                                              [UTCSDirectoryViewController new],
                                              [UTCSMoreViewController new]];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [self configureAppearance];
    return YES;
}

- (void)configureAppearance
{
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance]setTintColor:BURNT_ORANGE_COLOR];
}

@end
