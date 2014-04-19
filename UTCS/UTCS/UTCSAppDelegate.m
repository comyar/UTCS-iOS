//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Comyar Zaheri on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// View controllers
#import "UTCSLabsViewController.h"
#import "UTCSMenuViewController.h"
#import "UTCSNewsViewController.h"
#import "UTCSEventsViewController.h"
#import "UTCSSettingsViewController.h"
#import "UTCSDiskQuotaViewController.h"
#import "UTCSDirectoryViewController.h"
#import "UTCSVerticalMenuViewController.h"

// Models
#import "UTCSAppDelegate.h"

// Categories
#import "UIColor+UTCSColors.h"


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate ()

// -----
// @name Content controllers
// -----

@property (nonatomic) UTCSNewsViewController            *newsViewController;

//
@property (nonatomic) UTCSMenuViewController            *menuViewController;

//
@property (nonatomic) UTCSVerticalMenuViewController    *verticalMenuViewController;

//
@property (nonatomic) UTCSDiskQuotaViewController       *diskQuotaViewController;

// -----
// @name Navigation controllers
// -----

//
@property (nonatomic) UINavigationController            *labsNavigationController;

//
@property (nonatomic) UINavigationController            *newsNavigationController;

//
@property (nonatomic) UINavigationController            *eventsNavigationController;

//
@property (nonatomic) UINavigationController            *directoryNavigationController;

//
@property (nonatomic) UINavigationController            *settingsNavigationController;

@end


#pragma mark - UTCSAppDelegate Implementation

@implementation UTCSAppDelegate
@synthesize window;

#pragma mark UIApplicationDelegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize menu view controller
    self.menuViewController = [UTCSMenuViewController new];
    self.menuViewController.delegate = self;
    
    // News
    self.newsViewController             = [UTCSNewsViewController new];
    self.newsNavigationController       = [[UINavigationController alloc]initWithRootViewController:self.newsViewController];
    
    self.eventsNavigationController     = [[UINavigationController alloc]initWithRootViewController:[UTCSEventsViewController new]];
    self.labsNavigationController       = [[UINavigationController alloc]initWithRootViewController:[UTCSLabsViewController new]];
    self.directoryNavigationController  = [[UINavigationController alloc]initWithRootViewController:[UTCSDirectoryViewController new]];
    self.settingsNavigationController   = [[UINavigationController alloc]initWithRootViewController:[UTCSSettingsViewController new]];
    self.diskQuotaViewController        = [UTCSDiskQuotaViewController new];
    
    self.verticalMenuViewController = [[UTCSVerticalMenuViewController alloc]initWithMenuViewController:self.menuViewController
                                                                                  contentViewController:self.newsNavigationController];

    
    [self configureAppearance];
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.rootViewController = self.verticalMenuViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if(self.verticalMenuViewController.contentViewController == self.newsNavigationController) {
        [self.newsViewController update];
    } else if(self.verticalMenuViewController.contentViewController == self.eventsNavigationController) {
        
    } else if(self.verticalMenuViewController.contentViewController == self.labsNavigationController) {
        
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)configureAppearance
{
    [[UISearchBar appearance]setBackgroundImage:[UIImage new]];
    [[UISearchBar appearance]setScopeBarBackgroundImage:[UIImage new]];
    
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

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
