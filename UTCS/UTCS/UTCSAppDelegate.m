//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Henri Sweers on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAppDelegate.h"
#import "UTCSMenuViewController.h"
#import "UTCSNewsViewController.h"
#import "UTCSEventsViewController.h"
#import "UTCSLabsViewController.h"
#import "UTCSDirectoryViewController.h"
#import "UTCSSettingsViewController.h"
#import "UTCSAboutViewController.h"
#import "UIColor+UTCSColors.h"
#import "UTCSApplication.h"

#import "UTCSVerticalMenuViewController.h"
#import "UTCSWebViewController.h"


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate ()

//
@property (nonatomic) UTCSMenuViewController            *menuViewController;

@property (nonatomic) UINavigationController            *newsNavigationController;

//
@property (nonatomic) UINavigationController            *eventsNavigationController;

@property (nonatomic) UINavigationController            *labsNavigationController;

@property (nonatomic) UINavigationController            *directoryNavigationController;

@property (nonatomic) UINavigationController            *settingsNavigationController;

@property (nonatomic) UTCSAboutViewController           *aboutViewController;

//
@property (nonatomic) UTCSVerticalMenuViewController    *verticalMenuViewController;

@property (nonatomic) UTCSWebViewController             *webViewController;

@end


#pragma mark - UTCSAppDelegate Implementation

@implementation UTCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self loadReveal];
    
    // Initialize Parse
    [Parse setApplicationId:@"mPdTdFAb9WBPs2EOAQ8UmUGV03cFE7ZyruO3PhPJ"
                  clientKey:@"JJf7dzHkAaawjGMSLPN7N2HXzfII3svZoCIqxx8V"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    

    self.webViewController = [UTCSWebViewController new];

    ((UTCSApplication *)application).urlHandler = ^ BOOL(NSURL *url) {
        self.webViewController.url = url;
        [self.window.rootViewController presentViewController:self.webViewController animated:YES completion:nil];
        return YES;
    };
    
    
    [self configureAppearance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
   
    // Initialize menu view controller
    self.menuViewController = [UTCSMenuViewController new];
    self.menuViewController.delegate = self;
    
    // Initialize view controllers
    self.newsNavigationController       = [[UINavigationController alloc]initWithRootViewController:[UTCSNewsViewController new]];
    self.eventsNavigationController     = [[UINavigationController alloc]initWithRootViewController:[UTCSEventsViewController new]];
    self.labsNavigationController       = [[UINavigationController alloc]initWithRootViewController:[UTCSLabsViewController new]];
    self.directoryNavigationController  = [[UINavigationController alloc]initWithRootViewController:[UTCSDirectoryViewController new]];
    self.aboutViewController            = [UTCSAboutViewController new];
    self.settingsNavigationController   = [[UINavigationController alloc]initWithRootViewController:[UTCSSettingsViewController new]];
    
    self.verticalMenuViewController = [[UTCSVerticalMenuViewController alloc]initWithMenuViewController:[[UINavigationController alloc]initWithRootViewController:self.menuViewController] contentViewController:self.newsNavigationController];
    
    self.window.rootViewController = self.verticalMenuViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)configureAppearance
{
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    [[UINavigationBar appearance]setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UISearchBar appearance]setBackgroundImage:[UIImage new]];
    [[UISearchBar appearance]setScopeBarBackgroundImage:[UIImage new]];
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
    } else if(option == UTCSMenuOptionSettings) {
//        self.verticalMenuViewController.contentViewController = self.settingsNavigationController;
    }
}

- (void)didDismissWebViewController:(UTCSWebViewController *)webViewController
{
    [webViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - Reveal

#import <dlfcn.h>
- (void)loadReveal
{
    NSString *revealLibName = @"libReveal";
    NSString *revealLibExtension = @"dylib";
    NSString *dyLibPath = [[NSBundle mainBundle] pathForResource:revealLibName ofType:revealLibExtension];
    NSLog(@"Loading dynamic library: %@", dyLibPath);
    
    void *revealLib = NULL;
    revealLib = dlopen([dyLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    
    if (revealLib == NULL)
    {
        char *error = dlerror();
        NSLog(@"dlopen error: %s", error);
        NSString *message = [NSString stringWithFormat:@"%@.%@ failed to load with error: %s", revealLibName, revealLibExtension, error];
        [[[UIAlertView alloc] initWithTitle:@"Reveal library could not be loaded" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}



@end
