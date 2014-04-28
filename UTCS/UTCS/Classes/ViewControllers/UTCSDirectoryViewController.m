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
#import "UTCSDirectoryTableViewCell.h"
#import "UTCSDirectoryDataSourceSearchController.h"


#pragma mark - Constants



#pragma mark - UTCSDirectoryViewController Class Extension

@interface UTCSDirectoryViewController ()

// Search bar
@property (nonatomic) UISearchBar               *searchBar;

@property (nonatomic) UIButton                  *searchButton;

@property (nonatomic) UISearchDisplayController *directorySearchDisplayController;
@end


#pragma mark - UTCSDirectoryViewController Implementation

@implementation UTCSDirectoryViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.dataSource = [[UTCSDirectoryDataSource alloc]initWithService:@"directory"];
        self.dataSource.delegate = self;
        
        self.backgroundImageView.image = [UIImage imageNamed:@"eventsBackground-blurred"];
        
        self.searchBar = ({
            UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 64.0)];
            searchBar.backgroundImage = [UIImage new];
            searchBar.placeholder = @"Search Directory";
            searchBar.scopeButtonTitles = @[@"All", @"Faculty", @"Staff", @"Graduate"];
            searchBar.scopeBarBackgroundImage = [UIImage new];
            searchBar.tintColor = [UIColor whiteColor];
            searchBar.searchTextPositionAdjustment = UIOffsetMake(8.0, 0.0);
            [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarBackground"]
                                            forState:UIControlStateNormal];
            searchBar;
        });
        
        
        self.searchButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *image = [[UIImage imageNamed:@"search"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.tintColor = [UIColor whiteColor];
            [button addSubview:imageView];
            
            button;
        });
        
        self.tableView.tableHeaderView = self.searchBar;
        self.tableView.alwaysBounceVertical = NO;
        self.tableView.sectionIndexColor = [UIColor whiteColor];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = (UTCSDirectoryDataSource *)self.dataSource;
        
        self.dataSource.searchController.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar
                                                                                                    contentsController:self];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.height);
    [self update];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view insertSubview:self.searchButton belowSubview:self.menuButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.searchButton.frame = CGRectMake(self.view.width - 40, 8.0, 36, 36);
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.searchButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
        [self.searchDisplayController setActive:YES animated:YES];
    }
}


#pragma mark Updating

- (void)update
{
    if ([self.dataSource shouldUpdate]) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = @"Syncing";
        
        [self updateWithArgument:nil completion:^(BOOL success, BOOL cacheHit) {
            
            if (success && !cacheHit) {
                [((UTCSDirectoryDataSource *)self.dataSource) buildFlatDirectory];
                [self.tableView reloadData];
                self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.height);
            } else if (!success && !cacheHit) {
                // frowny face
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

#pragma mark UITableViewDelegate Methpds

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0.0 && [self.tableView.subviews count] > 0) {
        UIView *subview = self.tableView.subviews[0];
        subview.alpha = 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 64.0;
    
    UTCSDirectoryPerson *person = nil;
    
    if (tableView == self.tableView) {
        person = self.dataSource.data[indexPath.section][indexPath.row];
        
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        person = ((UTCSDirectoryDataSource *)self.dataSource).flatDirectory[indexPath.row];
        
    }
    
    if (person.office) {
        height += 16.0;
    }
    
    if (person.phoneNumber) {
        height += 16.0;
    }
    
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [UIView new];
    } else if (tableView == self.tableView) {
        UTCSDirectoryPerson *person = self.dataSource.data[section][0];
        NSString *letter = [[person.lastName substringToIndex:1]uppercaseString];
        return ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width - 8.0, 16.0)];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            label.text = [NSString stringWithFormat:@"    %@", letter];
            label.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
            label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
            label;
        });
    }
    return nil;
}

#pragma mark UTCSDataSourceCacheDelegate Methods

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource
{
    return @{UTCSDirectoryCacheKey: self.dataSource.data,
             UTCSDirectoryFlatCacheKey :((UTCSDirectoryDataSource *)self.dataSource).flatDirectory};
}

@end
