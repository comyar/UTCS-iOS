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




#pragma mark - UTCSLabsViewController Class Extension

@interface UTCSLabsViewController ()

//
@property (nonatomic) UIScrollView *scrollView;

//
@property (nonatomic) UTCSLabMachineViewController          *thirdFloorLabViewController;

//
@property (nonatomic) UTCSLabMachineViewController          *basementLabViewController;

//
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
    
    // Scroll View
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(2.0 * self.view.width, self.view.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    // Third floor lab view controller
    UTCSLabViewLayout *thirdLayout = [[UTCSLabViewLayout alloc]initWithFilename:@"ThirdFloorLabLayout"];
    self.thirdFloorLabViewController = [[UTCSLabMachineViewController alloc]initWithLayout:thirdLayout];
    
    self.basementLabViewController.backgroundImageView.image = [UIImage imageNamed:@"thirdLabsBackground"];
    
    self.thirdFloorLabViewController.view.frame = CGRectMake(0.0, 0.0, self.view.width, self.view.height);
    [self.scrollView addSubview:self.thirdFloorLabViewController.view];
    [self addChildViewController:self.thirdFloorLabViewController];
    [self.thirdFloorLabViewController didMoveToParentViewController:self];
    
    
    
    self.thirdFloorLabViewController.shimmeringView.frame = CGRectMake(0.5 * self.view.width,0.3 * self.view.height,
                                                                       0.4 * self.view.width, 0.6 * self.view.height);
    self.thirdFloorLabViewController.shimmeringView.contentView.frame = self.thirdFloorLabViewController.shimmeringView.bounds;
    ((UILabel *)self.thirdFloorLabViewController.shimmeringView.contentView).text = @"Third Floor";
    
    
    // Basement view controller
    self.basementLabViewController = [[UTCSLabMachineViewController alloc]initWithLayout:[[UTCSLabViewLayout alloc]initWithFilename:@"BasementLabLayout"]];
    self.basementLabViewController.view.backgroundColor = [UIColor blackColor];
    self.basementLabViewController.backgroundImageView.image = [UIImage imageNamed:@"thirdLabsBackground"];
    self.basementLabViewController.view.frame = CGRectMake(self.view.width, 0.0, self.view.width, self.view.height);
    [self.scrollView addSubview:self.basementLabViewController.view];
    [self addChildViewController:self.basementLabViewController];
    [self.basementLabViewController didMoveToParentViewController:self];
    
    self.basementLabViewController.shimmeringView.frame = CGRectMake(8.0, 0.72 * self.view.height, self.view.width - 16.0, 120);
    self.basementLabViewController.shimmeringView.contentView.frame = self.basementLabViewController.shimmeringView.bounds;
    ((UILabel *)self.basementLabViewController.shimmeringView.contentView).text = @"Basement";
    
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0.0, self.view.height - 32, self.view.width, 32)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = 2;
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
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = @"Updating";
        self.thirdFloorLabViewController.shimmeringView.shimmering = YES;
        self.basementLabViewController.shimmeringView.shimmering = YES;
        
        [self updateWithArgument:nil completion:^(BOOL success, BOOL cacheHit) {
            
            self.thirdFloorLabViewController.shimmeringView.shimmering = NO;
            self.basementLabViewController.shimmeringView.shimmering = NO;
            
            if (success) {
                NSDictionary *third      = self.dataSource.data[@"third"];
                NSDictionary *basement   = self.dataSource.data[@"basement"];
                
                self.thirdFloorLabViewController.machines = third;
                
                self.basementLabViewController.machines = basement;

            } else {
                // Frowny face
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }];
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageNumber = lround((MAX(0, scrollView.contentOffset.x)/self.view.width));
    self.pageControl.currentPage = pageNumber;
    
    CGFloat thirdOffset     = 0.5 * scrollView.contentOffset.x;
    CGFloat basementOffset  = 0.5 * (scrollView.contentOffset.x - self.view.width);
    self.thirdFloorLabViewController.imageOffset = CGPointMake(thirdOffset, 0.0);
    self.basementLabViewController.imageOffset = CGPointMake(basementOffset, 0.0);
    
}

#pragma mark UTCSDataSourceDelegate Methods

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource
{
    return @{UTCSLabsDataSourceCacheKey: self.dataSource.data};
}

@end
