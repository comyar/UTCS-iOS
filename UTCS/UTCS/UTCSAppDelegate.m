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
@property (strong, nonatomic) UTCSMenuViewController        *menuViewController;

@property (nonatomic) UTCSNewsViewController                *newsViewController;

//
@property (strong, nonatomic) UINavigationController        *eventsNavigationController;

@property (strong, nonatomic) UTCSLabsViewController        *labsViewController;

//
@property (strong, nonatomic) UINavigationController        *directoryNavigationController;

@property (strong, nonatomic) UTCSVerticalMenuViewController *verticalMenuViewController;

@end


#pragma mark - UTCSAppDelegate Implementation

@implementation UTCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self loadReveal];
    
    // Initialize Parse
    [Parse setApplicationId:@"WyRM4LmrPsZGdTuPoPUu1gLwWugasEMrWvUbDB6Y"
                  clientKey:@"KfrKIwFqyWV8zKcW9bmeFqpFyr54Ew6tgt2t0t0N"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
   
    // Initialize menu view controller
    self.menuViewController = [[UTCSMenuViewController alloc]initWithStyle:UITableViewStylePlain];
    self.menuViewController.delegate = self;
    
    // Initialize main view controllers
    self.newsViewController = [UTCSNewsViewController new];
    
    self.eventsNavigationController = [[UINavigationController alloc]initWithRootViewController:[UTCSEventsViewController new]];
    [self roundCornersOfView:self.eventsNavigationController.view];
    
    self.verticalMenuViewController = [[UTCSVerticalMenuViewController alloc]initWithMenuViewController:self.menuViewController contentViewController:self.newsViewController];
    
    self.window.rootViewController = self.verticalMenuViewController;
    [self.window makeKeyAndVisible];
    [self configureAppearance];
    return YES;
}

#pragma mark UTCSMenuViewControllerDelegate Methods

- (void)didSelectMenuOption:(UTCSMenuOptions)option
{
//    if(option == UTCSMenuOptionNews) {
//        [self.sideMenuViewController setContentViewController:self.newsNavigationController animated:YES];
//    } else if(option == UTCSMenuOptionEvents) {
//        [self.sideMenuViewController setContentViewController:self.eventsNavigationController animated:YES];
//    } else if(option == UTCSMenuOptionLabs) {
//        if(!self.labsViewController) {
//            self.labsViewController = [UTCSLabsViewController new];
//            [self roundCornersOfView:self.labsViewController.view];
//        }
//        [self.sideMenuViewController setContentViewController:self.labsViewController animated:YES];
//    } else if(option == UTCSMenuOptionDirectory) {
//        if(!self.directoryNavigationController) {
//            self.directoryNavigationController = [[UINavigationController alloc]initWithRootViewController:[UTCSDirectoryViewController new]];
//            [self roundCornersOfView:self.directoryNavigationController.view];
//        }
//        [self.sideMenuViewController setContentViewController:self.directoryNavigationController animated:YES];
//    }
//    [self.sideMenuViewController hideMenuViewController];
 }

#pragma mark Configure Appearance

- (void)configureAppearance
{
    [[UINavigationBar appearance]setBackgroundImage:[[UIImage imageNamed:@"navbarBackground"]resizableImageWithCapInsets:UIEdgeInsetsZero]
                                      forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setShadowImage:[[UIImage imageNamed:@"navbarShadow"]resizableImageWithCapInsets:UIEdgeInsetsZero]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor utcsBarTintColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor utcsBurntOrangeColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:22]}];
    [[UISearchBar appearance]setBarTintColor:[UIColor utcsBarTintColor]];
    [[UISearchBar appearance]setTintColor:[UIColor utcsBurntOrangeColor]];

}

- (void)roundCornersOfView:(UIView *)view
{
    view.layer.cornerRadius = 4.0;
    view.layer.masksToBounds = YES;
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
