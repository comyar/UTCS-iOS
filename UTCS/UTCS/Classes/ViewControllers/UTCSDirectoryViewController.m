//
//  UTCSDirectoryViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UTCSDirectoryViewController.h"
#import "UTCSDirectoryDataSource.h"
#import "UTCSDirectoryPerson.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+CZTinting.h"
#import "MBProgressHUD.h"


#pragma mark - Constants
// Key used to cache directory
static NSString *directoryCacheKey = @"directory";

// Key used to cache flat directory
static NSString *flatDirectoryCacheKey = @"flatDirectory";


#pragma mark - UTCSDirectoryViewController Class Extension

@interface UTCSDirectoryViewController ()

// Search bar
@property (nonatomic) UISearchBar               *searchBar;

// Button to scroll to the top of the table view
@property (nonatomic) UIButton                  *scrollToTopButton;

@end


#pragma mark - UTCSDirectoryViewController Implementation

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataSource = [[UTCSDirectoryDataSource alloc]initWithService:@"directory"];
        self.tableView.dataSource = (UTCSDirectoryDataSource *)self.dataSource;
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.rowHeight = 64.0;
    }
    return self;
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
        progressHUD.labelText = @"Syncing Directory...";
        
        [self updateWithArgument:nil completion:^(BOOL success) {
            
            if (success) {
                [((UTCSDirectoryDataSource *)self.dataSource) buildFlatDirectory];
                [self.tableView reloadData];
            } else {
                NSLog(@"directory failed");
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

#pragma mark UTCSDataSourceCacheDelegate Methods

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource
{
    return @{directoryCacheKey: self.dataSource.data,
             flatDirectoryCacheKey :((UTCSDirectoryDataSource *)self.dataSource).flatDirectory};
}

@end
