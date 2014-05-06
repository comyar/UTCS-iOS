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
#import "UTCSDirectoryDataSourceSearchController.h"
#import "UIButton+UTCSButton.h"
#import "UTCSDirectoryDetailViewController.h"


#pragma mark - Constants



#pragma mark - UTCSDirectoryViewController Class Extension

@interface UTCSDirectoryViewController ()

// Search bar
@property (nonatomic) UISearchBar               *searchBar;

@property (nonatomic) UIButton                  *searchButton;

@property (nonatomic) UTCSDirectoryDetailViewController *detailViewController;

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
        
        self.view.backgroundColor = [UIColor clearColor];
        
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
        
        
        
        self.tableView.tableHeaderView = self.searchBar;
        self.tableView.alwaysBounceVertical = NO;
        self.tableView.sectionIndexColor = [UIColor whiteColor];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = (UTCSDirectoryDataSource *)self.dataSource;
        self.tableView.rowHeight = 64.0;
        
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
    
    self.searchButton = ({
        UIButton *button = [UIButton bouncyButton];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(self.view.width - 44.0, 0.0, 44.0, 44.0);
        
        UIImage *image = [[UIImage imageNamed:@"search"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.tintColor = [UIColor whiteColor];
        imageView.frame = button.bounds;
        [button addSubview:imageView];
        
        button;
    });
    
    [self.view addSubview:self.searchButton];
    [self.view bringSubviewToFront:self.searchButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.searchButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:NO];
        [self.searchBar becomeFirstResponder];
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

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSDirectoryPerson *person = self.dataSource.data[indexPath.section][indexPath.row];
    
    if (!self.detailViewController) {
        self.detailViewController = [UTCSDirectoryDetailViewController new];
    }
    
    self.detailViewController.person = person;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
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
