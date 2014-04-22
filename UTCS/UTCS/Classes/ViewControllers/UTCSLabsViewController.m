//
//  UTCSLabsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSLabsViewController.h"
#import "MBProgressHUD.h"
#import "UTCSLabsDataSource.h"
#import "UTCSLabMachine.h"
#import "UIImage+ImageEffects.h"

#import "UTCSLabMachineViewController.h"



#pragma mark - UTCSLabsViewController Class Extension

@interface UTCSLabsViewController () 

//
@property (nonatomic) UIPageViewController                  *pageViewController;

//
@property (nonatomic) UTCSLabMachineViewController          *thirdFloorLabViewController;

//
@property (nonatomic) UTCSLabMachineViewController          *basementLabViewController;

@end


#pragma mark - UTCSLabsViewController Implementation

@implementation UTCSLabsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataSource = [[UTCSLabsDataSource alloc]initWithService:@"labs"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                             navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                           options:@{UIPageViewControllerOptionInterPageSpacingKey: @(8.0)}];
    self.pageViewController.view.backgroundColor = [UIColor blackColor];
    self.pageViewController.dataSource = self;
    
    self.pageViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.pageViewController setViewControllers:@[self.thirdFloorLabViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

- (void)update
{
    if ([self.dataSource shouldUpdate]) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.pageViewController.view animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = @"Updating";
        
        [self updateWithArgument:nil completion:^(BOOL success) {
            
            if (success) {
//                NSDictionary *third = self.dataSource.data[@"third"];
//                NSDictionary *basement = self.dataSource.data[@"basement"];
                
                // Pass to collection view data source
                
            } else {
                // Frowny face
            }
            
            [MBProgressHUD hideAllHUDsForView:self.pageViewController.view animated:YES];
            
        }];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (viewController == self.thirdFloorLabViewController) {
        return self.thirdFloorLabViewController;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (viewController == self.basementLabViewController) {
        return self.thirdFloorLabViewController;
    }
    
    return nil;
}

@end
