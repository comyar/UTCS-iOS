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
@property (nonatomic) UIScrollView *scrollView;

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
    self.thirdFloorLabViewController.backgroundImageView.image = [UIImage imageNamed:@"thirdLabsBackground"];
    self.thirdFloorLabViewController.view.frame = CGRectMake(0.0, 0.0, self.view.width, self.view.height);
    [self.scrollView addSubview:self.thirdFloorLabViewController.view];
    [self addChildViewController:self.thirdFloorLabViewController];
    [self.thirdFloorLabViewController didMoveToParentViewController:self];
    
    // Third shimmering view
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
    
    
    // Basement view controller
    self.basementLabViewController = [[UTCSLabMachineViewController alloc]initWithLayout:[[UTCSLabViewLayout alloc]initWithFilename:@"BasementLabLayout"]];
    self.basementLabViewController.view.backgroundColor = [UIColor blackColor];
    self.basementLabViewController.backgroundImageView.image = [UIImage imageNamed:@"basementLabsBackground"];
    self.basementLabViewController.view.frame = CGRectMake(self.view.width, 0.0, self.view.width, self.view.height);
    [self.scrollView addSubview:self.basementLabViewController.view];
    [self addChildViewController:self.basementLabViewController];
    [self.basementLabViewController didMoveToParentViewController:self];
    
    // Basement shimmering view
    self.basementShimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(8.0,
                                                                                    0.75 * self.view.height,
                                                                                    self.view.width - 16.0,
                                                                                    120)];
    self.basementShimmeringView.contentView = ({
        UILabel *label = [[UILabel alloc]initWithFrame:self.basementShimmeringView.bounds];
        label.text = @"Basement Lab";
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label;
    });
    [self.basementLabViewController.view addSubview:self.basementShimmeringView];
    
    
    
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0.0, self.view.height - 32, self.view.width, 32)];
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
        self.thirdShimmeringView.shimmering = YES;
        self.basementShimmeringView.shimmering = YES;
        
        [self updateWithArgument:nil completion:^(BOOL success, BOOL cacheHit) {
            
            self.thirdShimmeringView.shimmering = NO;
            self.basementShimmeringView.shimmering = NO;
            
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

@end
