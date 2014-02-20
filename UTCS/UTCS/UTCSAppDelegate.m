//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAppDelegate.h"
#import "UTCSNewsViewController.h"
#import "UTCSMenuViewController.h"


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate ()

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
    self.window.backgroundColor = [UIColor blackColor];
   
    self.menuViewController = [[UTCSMenuViewController alloc]initWithStyle:UITableViewStyleGrouped];
    self.contentViewController = [[UINavigationController alloc]initWithRootViewController:[UTCSNewsViewController new]];
    self.contentViewController.view.layer.cornerRadius = 4.0;
    self.contentViewController.view.layer.masksToBounds = YES;

    self.sideMenuViewController = [[UTCSSideMenuViewController alloc]initWithContentViewController:self.contentViewController
                                                                                menuViewController:self.menuViewController];
    self.sideMenuViewController.backgroundImage         = [UIImage imageNamed:@"menuBackground"];
//    self.sideMenuViewController.blurredBackgroundImage  = [UIImage imageNamed:@"menuBackgroundBlurred"];
    
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
