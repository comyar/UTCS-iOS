//
//  UTCSLabsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "MBProgressHUD.h"
#import "UTCSLabMachine.h"
#import "FBShimmeringView.h"
#import "UTCSLabsDataSource.h"
#import "UTCSUpdateTextFactory.h"
#import "UTCSLabsViewController.h"
#import "UTCSLabMachineViewController.h"

#import "UIButton+UTCSButton.h"
#import "UIImage+Cacheless.h"


#pragma mark - UTCSLabsViewController Class Extension

@interface UTCSLabsViewController ()

// Paging scroll view
@property (nonatomic) UIScrollView                          *scrollView;

// Page control to indicate pages
@property (nonatomic) UIPageControl                         *pageControl;

// Button to refresh lab data
@property (nonatomic) UIButton                              *refreshButton;

// View controller for the basement lab map
@property (nonatomic) UTCSLabMachineViewController          *basementLabViewController;

// View controller for the third floor lab map
@property (nonatomic) UTCSLabMachineViewController          *thirdFloorLabViewController;

@end


#pragma mark - UTCSLabsViewController Implementation

@implementation UTCSLabsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataSource = [[UTCSLabsDataSource alloc]initWithService:@"labs"];
        self.dataSource.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Scroll View
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        scrollView.contentSize = CGSizeMake(2.0 * self.view.width, self.view.height);
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView;
    });
    [self.view addSubview:self.scrollView];
    
    // Third floor lab view controller
    UTCSLabViewLayout *thirdLayout      = [[UTCSLabViewLayout alloc]initWithFilename:@"ThirdFloorLabLayout"];
    self.thirdFloorLabViewController    = [[UTCSLabMachineViewController alloc]initWithLayout:thirdLayout];
    self.thirdFloorLabViewController.backgroundImageView.image = [UIImage cacheless_imageNamed:@"thirdLabsBackground"];
    
    // Add third floor lab view to scroll view
    self.thirdFloorLabViewController.view.frame = CGRectMake(0.0, 0.0, self.view.width, self.view.height);
    [self.scrollView addSubview:self.thirdFloorLabViewController.view];
    [self addChildViewController:self.thirdFloorLabViewController];
    [self.thirdFloorLabViewController didMoveToParentViewController:self];
    
    // Configure third floor shimmering view
    self.thirdFloorLabViewController.shimmeringView.frame = CGRectMake(0.5 * self.view.width,0.3 * self.view.height,
                                                                       0.4 * self.view.width, 0.6 * self.view.height);
    self.thirdFloorLabViewController.shimmeringView.contentView.frame = self.thirdFloorLabViewController.shimmeringView.bounds;
    ((UILabel *)self.thirdFloorLabViewController.shimmeringView.contentView).text = @"Third Floor";
    
    // Basement view controller
    UTCSLabViewLayout *basementLayout = [[UTCSLabViewLayout alloc]initWithFilename:@"BasementLabLayout"];
    self.basementLabViewController = [[UTCSLabMachineViewController alloc]initWithLayout:basementLayout];
    self.basementLabViewController.backgroundImageView.image = [UIImage cacheless_imageNamed:@"basementLabsBackground"];
    
    // Add basement lab view to scroll view
    self.basementLabViewController.view.frame = CGRectMake(self.view.width, 0.0, self.view.width, self.view.height);
    [self.scrollView addSubview:self.basementLabViewController.view];
    [self addChildViewController:self.basementLabViewController];
    [self.basementLabViewController didMoveToParentViewController:self];

    // Configure basement shimmering view
    self.basementLabViewController.shimmeringView.frame = CGRectMake(8.0, 0.72 * self.view.height, self.view.width - 16.0, 120);
    self.basementLabViewController.shimmeringView.contentView.frame = self.basementLabViewController.shimmeringView.bounds;
    ((UILabel *)self.basementLabViewController.shimmeringView.contentView).text = @"Basement";
    
    // Page control
    self.pageControl = ({
        UIPageControl *control = [[UIPageControl alloc]initWithFrame:CGRectMake(0.0, self.view.height - 32, self.view.width, 32)];
        control.userInteractionEnabled = NO;
        control.numberOfPages = 2;
        control;
    });
    [self.view addSubview:self.pageControl];
    
    // Refresh button
    self.refreshButton = ({
        UIButton *button = [UIButton bouncyButton];
        button.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
        button.center = CGPointMake(self.view.width - 33.0, 22.0);
        
        UIImage *image = [[UIImage imageNamed:@"refresh"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.tintColor = [UIColor whiteColor];
        imageView.frame = button.bounds;
        [button addSubview:imageView];
        
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.refreshButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateForced:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark Updating

- (void)updateForced:(BOOL)forced
{
    // Shimmer lab map labels
    self.thirdFloorLabViewController.shimmeringView.shimmering  = YES;
    self.basementLabViewController.shimmeringView.shimmering    = YES;
    
    if ([self.dataSource shouldUpdate]) {
        
        // Show updating HUD
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
        hud.labelText = [UTCSUpdateTextFactory randomUpdateText];
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    [self.dataSource updateWithArgument:nil completion:^(BOOL success, BOOL cacheHit) {
        
        self.thirdFloorLabViewController.shimmeringView.shimmering = NO;
        self.basementLabViewController.shimmeringView.shimmering = NO;
        
        if (success) {
            NSDictionary *third      = self.dataSource.data[@"third"];
            NSDictionary *basement   = self.dataSource.data[@"basement"];
            
            self.thirdFloorLabViewController.machines   = third;
            self.basementLabViewController.machines     = basement;
            
        } else {
            // Frowny face / Error message
        }
        
        [MBProgressHUD hideAllHUDsForView:self.scrollView animated:YES];
    }];
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.refreshButton) {
        [self updateForced:YES];
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageNumber = lround((MAX(0, scrollView.contentOffset.x)/self.view.width));
    self.pageControl.currentPage = pageNumber;
    
    CGFloat thirdOffset     = 0.5 * scrollView.contentOffset.x;
    CGFloat basementOffset  = 0.5 * (scrollView.contentOffset.x - self.view.width); // Compensate for being on second page
    
    self.thirdFloorLabViewController.imageOffset    = CGPointMake(thirdOffset, 0.0);
    self.basementLabViewController.imageOffset      = CGPointMake(basementOffset, 0.0);
    
}

#pragma mark UTCSDataSourceDelegate Methods

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource
{
    return @{UTCSLabsDataSourceCacheKey: self.dataSource.data};
}

@end
