//
//  UTCSAppDelegate.m
//  UTCS
//
//  Created by Comyar Zaheri on 1/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSAppDelegate.h"
#import "UIImage+Cacheless.h"

// View controllers
#import "UTCSMenuViewController.h"
#import "UTCSNewsViewController.h"
#import "UTCSLabsViewController.h"
#import "UTCSNavigationController.h"
#import "UTCSEventsViewController.h"
#import "UTCSSettingsViewController.h"
#import "UTCSDiskQuotaViewController.h"
#import "UTCSDirectoryViewController.h"
#import "UTCSVerticalMenuViewController.h"

// Managers
#import "UTCSStarredEventManager.h"
#import "UTCSAuthenticationManager.h"


/**
 UTCSAuthenticationAlertViewTag is used to identify an authentication alert view
 and associate it with the specific service that required authentication.
 */
typedef NS_ENUM(u_int16_t, UTCSAuthenticationAlertViewTag) {
    /** Tag for the labs service */
    UTCSLabsAuthenticationAlertViewTag = 1
};


#pragma mark - UTCSAppDelegate Class Extension

@interface UTCSAppDelegate () <UIAlertViewDelegate>

// Alert view used to authenticate the user (for any services that require authentication)
@property (nonatomic) UIAlertView                       *authenticationAlertView;

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
    
#if DEBUG
    self.window = [[FBTweakShakeWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
#else
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
#endif
    
    // Menu
    self.menuViewController = [UTCSMenuViewController new];
    self.menuViewController.delegate = self;
    
    // Initialize view controllers. News is the default service
    self.newsNavigationController       = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSNewsViewController new]];
    self.verticalMenuViewController     = [[UTCSVerticalMenuViewController alloc]initWithMenuViewController:self.menuViewController
                                                                                      contentViewController:self.newsNavigationController];
    
    self.window.rootViewController = self.verticalMenuViewController;
    [self.window makeKeyAndVisible];
    [self configureAppearance];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Purge any old starred events from disk
    [[UTCSStarredEventManager sharedManager]purgePastEvents];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Ensure any modifications to user defaults are synced back to disk
    // Forces a disk write (since writes are buffered)
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark Appearance

- (void)configureAppearance
{
    // Configure the appearance of the navigation bar
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setShadowImage:[UIImage new]];
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setBackgroundImage:[UIImage new]
                                                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[UTCSNavigationController class], nil]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

#pragma mark UTCSMenuViewControllerDelegate Methods

- (void)didSelectMenuOption:(UTCSMenuOptions)option
{
    /**
     Sets the content view controller in the vertical menu based on the user's selection. Will lazily load view controllers.
     Also handles presenting the authentication alert view for any services that require authentication.
     */
    
    if(option == UTCSMenuOptionNews) {              // News
        if (!self.newsNavigationController) {
            self.newsNavigationController = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSNewsViewController new]];
        }
        self.verticalMenuViewController.contentViewController = self.newsNavigationController;
        
    } else if(option == UTCSMenuOptionEvents) {     // Events
        if (!self.eventsNavigationController) {
            self.eventsNavigationController = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSEventsViewController new]];
        }
        self.verticalMenuViewController.contentViewController = self.eventsNavigationController;
        
    } else if(option == UTCSMenuOptionLabs) {       // Labs
        if ([UTCSAuthenticationManager sharedManager].authenticated) {
            if (!self.labsViewController) {
                self.labsViewController = [UTCSLabsViewController new];
            }
            self.verticalMenuViewController.contentViewController = self.labsViewController;
        } else {
            [self prepareAuthenticationAlertView];
            self.authenticationAlertView.tag = UTCSLabsAuthenticationAlertViewTag;
            self.authenticationAlertView.message = @"You must log into your CS account to view lab status information.";
            [self.authenticationAlertView show];
        }
        
    } else if(option == UTCSMenuOptionDirectory) {  // Directory
        if (!self.directoryNavigationController) {
            self.directoryNavigationController  = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSDirectoryViewController new]];
            self.directoryNavigationController.backgroundImageView.image = [UIImage cacheless_imageNamed:@"directoryBackground"];
            [self configureAppearance];
        }
        self.verticalMenuViewController.contentViewController = self.directoryNavigationController;
        
    } else if(option == UTCSMenuOptionDiskQuota) {  // Disk Quota
        if (!self.diskQuotaViewController) {
            self.diskQuotaViewController = [UTCSDiskQuotaViewController new];
        }
        self.verticalMenuViewController.contentViewController = self.diskQuotaViewController;
        
    } else if(option == UTCSMenuOptionSettings) {   // Settings
        if (!self.settingsNavigationController) {
            self.settingsNavigationController = [[UTCSNavigationController alloc]initWithRootViewController:[UTCSSettingsViewController new]];
            self.settingsNavigationController.backgroundImageView.image = [UIImage cacheless_imageNamed:@"settingsBackground"];
        }
        self.verticalMenuViewController.contentViewController = self.settingsNavigationController;
    }
}

#pragma mark Authentication

- (void)prepareAuthenticationAlertView
{
    if (!self.authenticationAlertView) {
        self.authenticationAlertView = [[UIAlertView alloc]initWithTitle:@"Authentication"
                                                                 message:@"You must log into your CS account to use this feature."
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                       otherButtonTitles:@"OK", nil];
        self.authenticationAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField *usernameTextField = [self.authenticationAlertView textFieldAtIndex:0];
        usernameTextField.placeholder = @"CS Unix Username";
        
        UITextField *passwordTextField = [self.authenticationAlertView textFieldAtIndex:1];
        passwordTextField.placeholder = @"Password";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.authenticationAlertView) {
        if (buttonIndex == 0) {     // Cancel button
            [self.verticalMenuViewController hideMenu];
        } else {
            
            // Show progress HUD
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.verticalMenuViewController.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Authenticating";
            
            NSString *username = [alertView textFieldAtIndex:0].text;
            NSString *password = [alertView textFieldAtIndex:1].text;
            
            [[UTCSAuthenticationManager sharedManager]authenticateUser:username
                                                          withPassword:password
                                                            completion:^(BOOL success, NSError *error)
            {
                if (success) {
                    // If authentication succeeded, show labs view controller
                    if (!self.labsViewController) {
                        self.labsViewController = [UTCSLabsViewController new];
                    }
                    self.verticalMenuViewController.contentViewController = self.labsViewController;
                } else {
                    // Otherwise, show failure alert view
                    UIAlertView *failureAlertView = [[UIAlertView alloc]initWithTitle:@"Authentication Failed"
                                                                              message:@"Ouch! Something went wrong."
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"Ok"
                                                                    otherButtonTitles:nil];
                    
                    // Set alert view message based on error code
                    if (error.code == UTCSAuthenticationConnectionErrorCode) {
                        failureAlertView.message = @"Please check your network connection.";
                    } else if (error.code == UTCSAuthenticationAccessDeniedErrorCode) {
                        failureAlertView.message = @"Please ensure your password is correct.";
                    }
                    [failureAlertView show];
                }
                
                // Always hide the progress HUD
                [MBProgressHUD hideHUDForView:self.verticalMenuViewController.view animated:YES];
            }];
        }
    }
}

@end
