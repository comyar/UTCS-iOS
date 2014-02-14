//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAppDelegate.h"
#import "UTCSSideMenuViewController.h"

@interface UTCSAppDelegate ()
@property (strong, nonatomic) UITableViewController         *menuViewController;
@property (strong, nonatomic) UINavigationController        *contentViewController;
@property (strong, nonatomic) UTCSSideMenuViewController    *sideMenuViewController;
@end

@implementation UTCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    self.menuViewController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    self.contentViewController = [[UINavigationController alloc]initWithRootViewController:[UIViewController new]];
    self.contentViewController.view.backgroundColor = [UIColor redColor];
    self.menuViewController.view.backgroundColor = [UIColor clearColor];
    self.sideMenuViewController = [[UTCSSideMenuViewController alloc]initWithContentController:self.contentViewController
                                                                                menuController:self.menuViewController];
    self.window.rootViewController = self.sideMenuViewController;
    
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
