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


#pragma mark - Constants
// Key used to cache directory
static NSString *directoryCacheKey = @"directory";

// Key used to cache flat directory
static NSString *flatDirectoryCacheKey = @"flatDirectory";


#pragma mark - UTCSDirectoryViewController Class Extension

@interface UTCSDirectoryViewController ()

@property (nonatomic) NSIndexPath               *selectedIndexPath;

// Search bar
@property (nonatomic) UISearchBar               *searchBar;

@property (nonatomic) UIButton                  *searchButton;

@property (nonatomic) UISearchDisplayController *directorySearchDisplayController;
@end


#pragma mark - UTCSDirectoryViewController Implementation

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        
        self.dataSource = [[UTCSDirectoryDataSource alloc]initWithService:@"directory"];
        self.tableView.dataSource = (UTCSDirectoryDataSource *)self.dataSource;
        self.backgroundImageView.image = [UIImage imageNamed:@"directoryBackground"];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.sectionIndexColor = [UIColor whiteColor];
        
        self.searchBar = ({
            UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 64.0)];
            searchBar.backgroundImage = [UIImage new];
            searchBar.tintColor = [UIColor utcsBurntOrangeColor];
            searchBar.placeholder = @"Search Directory";
            searchBar.scopeButtonTitles = @[@"All", @"Faculty", @"Staff", @"Graduates"];
            searchBar.scopeBarBackgroundImage = [UIImage new];
            searchBar;
        });
        self.tableView.tableHeaderView = self.searchBar;
        
        self.directorySearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
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
    
}

- (void)update
{
    if ([self.dataSource shouldUpdate]) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = @"Syncing Directory";
        
        [self updateWithArgument:nil completion:^(BOOL success) {
            
            if (success) {
                [((UTCSDirectoryDataSource *)self.dataSource) buildFlatDirectory];
                [self.tableView reloadData];
                self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.height);
            } else {
                NSLog(@"directory failed");
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}





#pragma mark UITableViewDelegate Methpds

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSDirectoryTableViewCell *previous = (UTCSDirectoryTableViewCell *)[tableView cellForRowAtIndexPath:self.selectedIndexPath];
    UTCSDirectoryTableViewCell *cell = (UTCSDirectoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
        self.selectedIndexPath = nil;
        cell.showDetails = NO;
    } else {
        self.selectedIndexPath = indexPath;
        cell.showDetails = YES;
    }
    previous.showDetails = NO;
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const CGFloat height = 64.0;
    if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
        UTCSDirectoryPerson *person = self.dataSource.data[indexPath.section][indexPath.row];
        CGFloat selectedHeight = height;
        if (person.office) {
            selectedHeight += 26.0;
        }
        
        if (person.phoneNumber) {
            selectedHeight += 26.0;
        }
        
        return selectedHeight;
    }
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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


#pragma mark UTCSDataSourceCacheDelegate Methods

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource
{
    return @{directoryCacheKey: self.dataSource.data,
             flatDirectoryCacheKey :((UTCSDirectoryDataSource *)self.dataSource).flatDirectory};
}

@end
