//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Comyar Zaheri on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSAppDelegate.h"

// -----
// @name View controllers
// -----

#import "UTCSWebViewController.h"
#import "UTCSLabsViewController.h"
#import "UTCSMenuViewController.h"
#import "UTCSNewsViewController.h"
#import "UTCSEventsViewController.h"
#import "UTCSSettingsViewController.h"
#import "UTCSDiskQuotaViewController.h"
#import "UTCSDirectoryViewController.h"
#import "UTCSVerticalMenuViewController.h"

// -----
// @name Categories
// -----

#import "UIColor+UTCSColors.h"


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate ()

//
@property (nonatomic) UTCSWebViewController             *webViewController;

//
@property (nonatomic) UTCSMenuViewController            *menuViewController;

//
@property (nonatomic) UTCSDiskQuotaViewController       *diskQuotaViewController;

//
@property (nonatomic) UINavigationController            *labsNavigationController;

//
@property (nonatomic) UINavigationController            *newsNavigationController;

//
@property (nonatomic) UINavigationController            *eventsNavigationController;

//
@property (nonatomic) UTCSVerticalMenuViewController    *verticalMenuViewController;

//
@property (nonatomic) UINavigationController            *directoryNavigationController;

//
@property (nonatomic) UINavigationController            *settingsNavigationController;

@end


#pragma mark - UTCSAppDelegate Implementation

@implementation UTCSAppDelegate

#pragma mark UIApplicationDelegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize Parse
    [Parse setApplicationId:@"mPdTdFAb9WBPs2EOAQ8UmUGV03cFE7ZyruO3PhPJ"
                  clientKey:@"JJf7dzHkAaawjGMSLPN7N2HXzfII3svZoCIqxx8V"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Initialize menu view controller
    self.menuViewController = [UTCSMenuViewController new];
    self.menuViewController.delegate = self;
    
    // Initialize view controllers
    self.webViewController              = [UTCSWebViewController new];
    self.diskQuotaViewController        = [UTCSDiskQuotaViewController new];
    self.newsNavigationController       = [[UINavigationController alloc]initWithRootViewController:[UTCSNewsViewController new]];
    self.eventsNavigationController     = [[UINavigationController alloc]initWithRootViewController:[UTCSEventsViewController new]];
    self.labsNavigationController       = [[UINavigationController alloc]initWithRootViewController:[UTCSLabsViewController new]];
    self.directoryNavigationController  = [[UINavigationController alloc]initWithRootViewController:[UTCSDirectoryViewController new]];
    self.settingsNavigationController   = [[UINavigationController alloc]initWithRootViewController:[UTCSSettingsViewController new]];
    
    self.verticalMenuViewController = [[UTCSVerticalMenuViewController alloc]initWithMenuViewController:self.menuViewController
                                                                                  contentViewController:self.newsNavigationController];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.rootViewController = self.verticalMenuViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//- (void)configureAppearance
//{
//    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
//    [[UINavigationBar appearance]setBackgroundColor:[UIColor clearColor]];
//    [[UINavigationBar appearance]setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
//    [[UISearchBar appearance]setBackgroundImage:[UIImage new]];
//    [[UISearchBar appearance]setScopeBarBackgroundImage:[UIImage new]];
//}

#pragma mark UTCSMenuViewControllerDelegate Methods

- (void)didSelectMenuOption:(UTCSMenuOptions)option
{
    if(option == UTCSMenuOptionNews) {
        self.verticalMenuViewController.contentViewController = self.newsNavigationController;
    } else if(option == UTCSMenuOptionEvents) {
        self.verticalMenuViewController.contentViewController = self.eventsNavigationController;
    } else if(option == UTCSMenuOptionLabs) {
        self.verticalMenuViewController.contentViewController = self.labsNavigationController;
    } else if(option == UTCSMenuOptionDirectory) {
        self.verticalMenuViewController.contentViewController = self.directoryNavigationController;
    } else if(option == UTCSMenuOptionDiskQuota) {
        self.verticalMenuViewController.contentViewController = self.diskQuotaViewController;
    } else if(option == UTCSMenuOptionSettings) {
        self.verticalMenuViewController.contentViewController = self.settingsNavigationController;
    }
}



@end
