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
#import "FBShimmeringView.h"
#import "UTCSUpdateTextFactory.h"

#import "UTCSLabMachineViewController.h"

#import "UTCSLabsSearchViewController.h"



#pragma mark - UTCSLabsViewController Class Extension

@interface UTCSLabsViewController ()

//
@property (nonatomic) UIPageViewController                  *pageViewController;

//
@property (nonatomic) UTCSLabMachineViewController          *thirdFloorLabViewController;

@property (nonatomic) FBShimmeringView                      *thirdShimmeringView;

@property (nonatomic) FBShimmeringView                      *basementShimmeringView;

//
@property (nonatomic) UTCSLabMachineViewController          *basementLabViewController;

@property (nonatomic) UTCSLabsSearchViewController          *searchViewController;

@property (nonatomic) UIPageControl                         *pageControl;

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
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0.0, self.view.height - 32, self.view.width, 32)];
    self.pageControl.numberOfPages = 3;
    
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                             navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                           options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.pageViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    self.thirdFloorLabViewController = [[UTCSLabMachineViewController alloc]initWithLayout:[[UTCSLabViewLayout alloc]initWithFilename:@"ThirdFloorLabLayout"]];
    self.thirdFloorLabViewController.backgroundImageView.image = [UIImage imageNamed:@"diskQuotaBackground"];
    
    
    self.thirdShimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0.5 * self.view.width,
                                                                                 0.3 * self.view.height,
                                                                                 0.4 * self.view.width,
                                                                                 0.6 * self.view.height)];
    self.thirdShimmeringView.contentView = ({
        UILabel *label = [[UILabel alloc]initWithFrame:self.thirdShimmeringView.bounds];
        label.text = @"Third\nFloor\nLab";
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label;
    });
    
    
    [self.thirdFloorLabViewController.view addSubview:self.thirdShimmeringView];
    
    self.basementLabViewController = [[UTCSLabMachineViewController alloc]initWithLayout:[[UTCSLabViewLayout alloc]initWithFilename:@"BasementLabLayout"]];
    self.basementLabViewController.backgroundImageView.image = [UIImage imageNamed:@"eventsBackground"];

    self.searchViewController = [UTCSLabsSearchViewController new];
    self.searchViewController.searchController.dataSource = self.dataSource;
    
    
    [self.pageViewController setViewControllers:@[self.searchViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    [self.view addSubview:self.pageControl];
    
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
        self.thirdShimmeringView.shimmering = YES;
        
        [self updateWithArgument:nil completion:^(BOOL success, BOOL cacheHit) {
            
            self.thirdShimmeringView.shimmering = NO;
            
            if (success) {
                NSDictionary *third      = self.dataSource.data[@"third"];
                NSDictionary *basement   = self.dataSource.data[@"basement"];
                
                NSLog(@"third");
                self.thirdFloorLabViewController.machines = third;
                
                NSLog(@"basement");
                self.basementLabViewController.machines = basement;

            } else {
                // Frowny face
            }

            [MBProgressHUD hideAllHUDsForView:self.pageViewController.view animated:YES];
            
        }];
    }
}

#pragma mark UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (viewController == self.thirdFloorLabViewController) {
        return self.basementLabViewController;
    } else if (viewController == self.basementLabViewController) {
        return self.searchViewController;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (viewController == self.searchViewController) {
        return self.basementLabViewController;
    } else if (viewController == self.basementLabViewController) {
        return self.thirdFloorLabViewController;
    }
    return nil;
}

#pragma mak UIPageViewControllerDelegate Methods


- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (completed) {
        UIViewController *previous = [previousViewControllers firstObject];
        UIViewController *current = [pageViewController.viewControllers firstObject];
        if (current == self.searchViewController) {
            // become first responder
        } else if (previous == self.searchViewController) {
            // resign first responder
        }
    }
}



@end
