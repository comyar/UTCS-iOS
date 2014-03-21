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
#import "UIColor+UTCSColors.h"

#import "UTCSVerticalMenuViewController.h"


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate ()

//
@property (strong, nonatomic) UTCSMenuViewController            *menuViewController;

@property (nonatomic) UTCSNewsViewController                    *newsViewController;

@property (nonatomic) UINavigationController                    *newsNavigationController;

//
@property (strong, nonatomic) UINavigationController            *eventsNavigationController;

@property (strong, nonatomic) UTCSLabsViewController            *labsViewController;

//
@property (strong, nonatomic) UINavigationController            *directoryNavigationController;

//
@property (strong, nonatomic) UTCSVerticalMenuViewController    *verticalMenuViewController;

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
    
    [self configureAppearance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
   
    // Initialize menu view controller
    self.menuViewController = [[UTCSMenuViewController alloc]initWithStyle:UITableViewStylePlain];
    self.menuViewController.delegate = self;
    
    // Initialize main view controllers
    self.newsViewController = [UTCSNewsViewController new];
    self.newsNavigationController = [[UINavigationController alloc]initWithRootViewController:self.newsViewController];
    
    
    self.eventsNavigationController = [[UINavigationController alloc]initWithRootViewController:[UTCSEventsViewController new]];
    
    self.verticalMenuViewController = [[UTCSVerticalMenuViewController alloc]initWithMenuViewController:self.menuViewController contentViewController:self.newsNavigationController];
    
    self.window.rootViewController = self.verticalMenuViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)configureAppearance
{
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    [[UINavigationBar appearance]setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark UTCSMenuViewControllerDelegate Methods

- (void)didSelectMenuOption:(UTCSMenuOptions)option
{

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
