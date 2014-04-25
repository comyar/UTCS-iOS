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

#import "UTCSThirdFloorLabViewLayout.h"
#import "UTCSBasementLabViewLayout.h"

#import "UTCSCardCollectionViewController.h"


#pragma mark - UTCSLabsViewController Class Extension

@interface UTCSLabsViewController ()

//
@property (nonatomic) UTCSCardCollectionViewController      *cardCollectionViewController;

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
    
    self.cardCollectionViewController = [UTCSCardCollectionViewController new];
    
    self.cardCollectionViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.cardCollectionViewController];
    [self.view addSubview:self.cardCollectionViewController.view];
    [self.cardCollectionViewController didMoveToParentViewController:self];
    
    
    self.thirdFloorLabViewController = [[UTCSLabMachineViewController alloc]initWithLayout:[UTCSThirdFloorLabViewLayout new]];
    
    self.basementLabViewController = [[UTCSLabMachineViewController alloc]initWithLayout:[UTCSBasementLabViewLayout new]];

    
    [self.cardCollectionViewController addChildViewControllerAsCard:self.thirdFloorLabViewController];
    [self.cardCollectionViewController addChildViewControllerAsCard:self.basementLabViewController];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self update];
}

- (void)update
{
//    if ([self.dataSource shouldUpdate]) {
////        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.pageViewController.view animated:YES];
////        progressHUD.mode = MBProgressHUDModeIndeterminate;
////        progressHUD.labelText = @"Updating";
//        
//        [self updateWithArgument:nil completion:^(BOOL success) {
//            
//            if (success) {
////                NSArray *third = self.dataSource.data[@"third"];
////                NSArray *basement = self.dataSource.data[@"basement"];
//                
////                [self.thirdFloorLabViewController updateLabMachineViewsWithLabMachines:@[third[0]]];
////                [self.basementLabViewController updateLabMachineViewsWithLabMachines:basement];
//                
//            } else {
//                // Frowny face
//            }
//            
////            [MBProgressHUD hideAllHUDsForView:self.pageViewController.view animated:YES];
//            
//        }];
//    }
}

@end
