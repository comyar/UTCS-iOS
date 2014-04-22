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

@interface UTCSLabsViewController () <UIPageViewControllerDataSource>

@property (nonatomic) UIPageViewController *pageViewController;

@property (nonatomic) UICollectionViewController *thirdCollectionViewController;
@property (nonatomic) UICollectionViewController *basementCollectionViewController;

@end

@implementation UTCSLabsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.backgroundColor = [UIColor clearColor];
    self.pageViewController.dataSource = self;
    
    self.pageViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.thirdCollectionViewController = [[UICollectionViewController alloc]initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    self.thirdCollectionViewController.collectionView.backgroundColor = [UIColor clearColor];
    
    self.basementCollectionViewController = [[UICollectionViewController alloc]initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    self.basementCollectionViewController.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.pageViewController setViewControllers:@[self.thirdCollectionViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (viewController == self.thirdCollectionViewController) {
        return self.basementCollectionViewController;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (viewController == self.basementCollectionViewController) {
        return self.thirdCollectionViewController;
    }
    
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    if ([pageViewController.viewControllers firstObject] == self.thirdCollectionViewController) {
        return 0;
    } else {
        return 1;
    }
}

@end
