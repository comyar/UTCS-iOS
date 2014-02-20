//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAppDelegate.h"
#import "UTCSNewsViewController.h"
#import "UTCSEventsViewController.h"
#import "UTCSMenuViewController.h"


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate ()

//
@property (strong, nonatomic) UTCSMenuViewController        *menuViewController;

//
@property (strong, nonatomic) UINavigationController        *newsNavigationController;

//
@property (strong, nonatomic) UINavigationController        *eventsNavigationController;

@end


#pragma mark - UTCSAppDelegate Implementation

@implementation UTCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
   
    // Initialize menu view controller
    self.menuViewController = [[UTCSMenuViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    // Initialize main view controllers
    self.newsNavigationController = [[UINavigationController alloc]initWithRootViewController:[UTCSNewsViewController new]];
    self.eventsNavigationController = [[UINavigationController alloc]initWithRootViewController:[UTCSEventsViewController new]];
    
    // Initialize side menu view controller
    self.sideMenuViewController = [[UTCSSideMenuViewController alloc]initWithContentViewController:self.newsNavigationController
                                                                                menuViewController:self.menuViewController];
    self.sideMenuViewController.backgroundImage = [UIImage imageNamed:@"menuBackground"];
    
    self.window.rootViewController = self.sideMenuViewController;
    [self.window makeKeyAndVisible];
    [self configureAppearance];
    return YES;
}

#pragma mark Configure Appearance

- (void)configureAppearance
{
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTintColor:COLOR_BURNT_ORANGE];
    [self roundCornersOfView:self.newsNavigationController.view];
    [self roundCornersOfView:self.eventsNavigationController.view];
}

- (void)roundCornersOfView:(UIView *)view
{
    view.layer.cornerRadius = 4.0;
    view.layer.masksToBounds = YES;
}



@end
