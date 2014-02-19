//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAppDelegate.h"
#import "UTCSSideMenuViewController.h"
#import "UTCSNewsViewController.h"
#import "UTCSMenuViewController.h"


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate ()

//
@property (strong, nonatomic) UTCSSideMenuViewController    *sideMenuViewController;

//
@property (strong, nonatomic) UTCSMenuViewController        *menuViewController;

//
@property (strong, nonatomic) UINavigationController        *contentViewController;

@end


#pragma mark - UTCSAppDelegate Implementation

@implementation UTCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    self.menuViewController = [UTCSMenuViewController new];
    self.contentViewController = [[UINavigationController alloc]initWithRootViewController:[UTCSNewsViewController new]];

    self.sideMenuViewController = [[UTCSSideMenuViewController alloc]initWithContentViewController:self.contentViewController
                                                                                menuViewController:self.menuViewController];
    self.sideMenuViewController.backgroundImage         = [UIImage imageNamed:@"menuBackground"];
    self.sideMenuViewController.blurredBackgroundImage  = [UIImage imageNamed:@"menuBackgroundBlurred"];
    self.window.rootViewController = self.sideMenuViewController;
    
    [self.window makeKeyAndVisible];
    [self configureAppearance];
    return YES;
}

- (void)configureAppearance
{
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
}

@end
