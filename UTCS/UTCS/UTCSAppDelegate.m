//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Comyar Zaheri on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSAppDelegate.h"
#import <Tweaks/FBTweakInline.h>

#import "UTCSMenuViewController.h"
#import "UTCSNavigationController.h"
#import "UTCSVerticalMenuViewController.h"

#import "UTCSNewsViewController.h"
#import "UTCSEventsViewController.h"
#import "UTCSLabsViewController.h"
#import "UTCSDiskQuotaViewController.h"
#import "UTCSDirectoryViewController.h"
#import "UTCSSettingsViewController.h"


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate ()

// -----
// @name Content controllers
// -----

// Menu view controller
@property (nonatomic) UTCSMenuViewController            *menuViewController;

// Vertical menu view controller
@property (nonatomic) UTCSVerticalMenuViewController    *verticalMenuViewController;

// Labs view controller
@property (nonatomic) UTCSLabsViewController            *labsViewController;

// Disk quota view controller
@property (nonatomic) UTCSDiskQuotaViewController       *diskQuotaViewController;

// -----
// @name Navigation controllers
// -----

// Navigation controller containing the news view controller
@property (nonatomic) UTCSNavigationController          *newsNavigationController;

// Navigation controller containing the events view controller
@property (nonatomic) UTCSNavigationController          *eventsNavigationController;

// Navigation controller containing the directory view controller
@property (nonatomic) UTCSNavigationController          *directoryNavigationController;

// Navigation controller containing the settings view controller
@property (nonatomic) UTCSNavigationController          *settingsNavigationController;

@end


#pragma mark - UTCSAppDelegate Implementation

@implementation UTCSAppDelegate

#pragma mark UIApplicationDelegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[FBTweakShakeWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    // Menu
    self.menuViewController = [UTCSMenuViewController new];
    self.menuViewController.delegate = self;
    
    // Navigation controllers
    self.newsNavigationController       = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSNewsViewController new]];
    self.verticalMenuViewController     = [[UTCSVerticalMenuViewController alloc]initWithMenuViewController:self.menuViewController
                                                                                      contentViewController:self.newsNavigationController];
    
    [self configureAppearance];
    self.window.rootViewController = self.verticalMenuViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark Appearance

- (void)configureAppearance
{
    NSDictionary *searchBarPlaceholderAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0 alpha:0.5]};
    NSAttributedString *searchBarPlaceholder = [[NSAttributedString alloc]initWithString:@"Search"
                                                                              attributes:searchBarPlaceholderAttributes];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]setAttributedPlaceholder:searchBarPlaceholder];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:FBTweakValue(@"UISearchBar", @"UITextField", @"Font Size", 20.0)]];
    
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setShadowImage:[UIImage new]];
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setBackgroundImage:[UIImage new]
                                                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    if (self.newsNavigationController != self.verticalMenuViewController.contentViewController) {
        self.newsNavigationController = nil;
    }
    
    if (self.eventsNavigationController != self.verticalMenuViewController.contentViewController) {
        self.eventsNavigationController = nil;
    }
    
    if (self.labsViewController != self.verticalMenuViewController.contentViewController) {
        self.labsViewController = nil;
    }
    
    if (self.directoryNavigationController != self.verticalMenuViewController.contentViewController) {
        self.directoryNavigationController = nil;
    }
    
    if (self.diskQuotaViewController != self.verticalMenuViewController.contentViewController) {
        self.diskQuotaViewController = nil;
    }
    
    if (self.settingsNavigationController != self.verticalMenuViewController.contentViewController) {
        self.settingsNavigationController = nil;
    }
}

#pragma mark UTCSMenuViewControllerDelegate Methods

- (void)didSelectMenuOption:(UTCSMenuOptions)option
{
    if(option == UTCSMenuOptionNews) {
        if (!self.newsNavigationController) {
            self.newsNavigationController = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSNewsViewController new]];
        }
        self.verticalMenuViewController.contentViewController = self.newsNavigationController;
    } else if(option == UTCSMenuOptionEvents) {
        if (!self.eventsNavigationController) {
            self.eventsNavigationController = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSEventsViewController new]];
        }
        self.verticalMenuViewController.contentViewController = self.eventsNavigationController;
    } else if(option == UTCSMenuOptionLabs) {
        if (!self.labsViewController) {
            self.labsViewController = [UTCSLabsViewController new];
        }
        self.verticalMenuViewController.contentViewController = self.labsViewController;
    } else if(option == UTCSMenuOptionDirectory) {
        if (!self.directoryNavigationController) {
            self.directoryNavigationController  = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSDirectoryViewController new]];
            self.directoryNavigationController.backgroundImageView.image = [UIImage imageNamed:@"directoryBackground"];
        }
        self.verticalMenuViewController.contentViewController = self.directoryNavigationController;
    } else if(option == UTCSMenuOptionDiskQuota) {
        if (!self.diskQuotaViewController) {
            self.diskQuotaViewController = [UTCSDiskQuotaViewController new];
        }
        self.verticalMenuViewController.contentViewController = self.diskQuotaViewController;
    } else if(option == UTCSMenuOptionSettings) {
        if (!self.settingsNavigationController) {
            self.settingsNavigationController = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSSettingsViewController new]];
            self.settingsNavigationController.backgroundImageView.image = [UIImage imageNamed:@"settingsBackground"];
        }
        self.verticalMenuViewController.contentViewController = self.settingsNavigationController;
    }
}

@end
