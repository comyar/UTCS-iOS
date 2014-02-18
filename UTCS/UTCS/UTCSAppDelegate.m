//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAppDelegate.h"
#import "UTCSSideMenuController.h"
#import "UTCSMenuViewController.h"

@interface UTCSAppDelegate ()
@property (strong, nonatomic) UTCSMenuViewController        *menuViewController;
@property (strong, nonatomic) UINavigationController        *contentViewController;
@end

@implementation UTCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    self.menuViewController = [UTCSMenuViewController new];
    self.contentViewController = [[UINavigationController alloc]initWithRootViewController:[UIViewController new]];
    self.contentViewController.view.backgroundColor = [UIColor whiteColor];

    UTCSSideMenuController *sideMenuViewController = [[UTCSSideMenuController alloc]initWithContentViewController:self.contentViewController menuViewController:self.menuViewController];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"menuBackgroundBlurred"];
    self.window.rootViewController = sideMenuViewController;
    
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
