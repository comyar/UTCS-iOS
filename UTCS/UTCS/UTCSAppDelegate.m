//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAppDelegate.h"
#import "UTCSMenuViewController.h"
#import "UTCSSideMenuViewController.h"
#import "UTCSNewsViewController.h"
#import "UTCSEventsViewController.h"
#import "UTCSLabsViewController.h"


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate ()

//
@property (strong, nonatomic) UTCSMenuViewController        *menuViewController;

//
@property (strong, nonatomic) UINavigationController        *newsNavigationController;

//
@property (strong, nonatomic) UINavigationController        *eventsNavigationController;

@property (strong, nonatomic) UTCSLabsViewController        *labsViewController;

//
@property (strong, nonatomic) UINavigationController        *directoryNavigationController;

@end


#pragma mark - UTCSAppDelegate Implementation

@implementation UTCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize Parse
    [Parse setApplicationId:@"mPdTdFAb9WBPs2EOAQ8UmUGV03cFE7ZyruO3PhPJ"
                  clientKey:@"JJf7dzHkAaawjGMSLPN7N2HXzfII3svZoCIqxx8V"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
   
    // Initialize menu view controller
    self.menuViewController = [[UTCSMenuViewController alloc]initWithStyle:UITableViewStyleGrouped];
    self.menuViewController.delegate = self;
    
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

#pragma mark UTCSMenuViewControllerDelegate Methods

- (void)didSelectMenuOption:(UTCSMenuOptions)option
{
    if(option == UTCSMenuOptionNews) {
        [self.sideMenuViewController setContentViewController:self.newsNavigationController animated:YES];
    } else if(option == UTCSMenuOptionEvents) {
        [self.sideMenuViewController setContentViewController:self.eventsNavigationController animated:YES];
    } else if(option == UTCSMenuOptionLabs) {
        if(!self.labsViewController) {
            self.labsViewController = [UTCSLabsViewController new];
        }
        [self.sideMenuViewController setContentViewController:self.labsViewController animated:YES];
    }
    [self.sideMenuViewController hideMenuViewController];
 }

#pragma mark Configure Appearance

- (void)configureAppearance
{
    [[UINavigationBar appearance]setBackgroundImage:[[UIImage imageNamed:@"navbarBackground"]resizableImageWithCapInsets:UIEdgeInsetsZero]
                                      forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setShadowImage:[[UIImage imageNamed:@"navbarShadow"]resizableImageWithCapInsets:UIEdgeInsetsZero]];
    [[UINavigationBar appearance]setTintColor:COLOR_BURNT_ORANGE];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_DARK_GRAY,
                                                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:22]}];
    [self roundCornersOfView:self.newsNavigationController.view];
    [self roundCornersOfView:self.eventsNavigationController.view];
}

- (void)roundCornersOfView:(UIView *)view
{
    view.layer.cornerRadius = 4.0;
    view.layer.masksToBounds = YES;
}



@end
