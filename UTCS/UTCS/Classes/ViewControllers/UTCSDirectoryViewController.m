//
//  UTCSDirectoryViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryViewController.h"
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"
#import "UTCSMenuButton.h"
#import "UIView+CZPositioning.h"
#import "UIImage+ImageEffects.h"
#import "UTCSDirectoryPerson.h"
#import "UTCSDirectoryDataSource.h"
#import "MBProgressHUD.h"

@interface UTCSDirectoryViewController ()

@property (nonatomic) UIImageView               *backgroundImageView;
@property (nonatomic) UTCSMenuButton            *menuButton;
@property (nonatomic) UITableView               *tableView;
@property (nonatomic) UISearchBar               *searchBar;
@property (nonatomic) UIButton                  *scrollToTopButton;
@property (nonatomic) UTCSDirectoryDataSource   *directoryDataSource;
@property (nonatomic) NSArray                   *searchResults;

@end

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.directoryDataSource = [UTCSDirectoryDataSource new];
        
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        self.backgroundImageView.image = [[UIImage imageNamed:@"directoryBackground"]applyDarkEffect];
        [self.view addSubview:self.backgroundImageView];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 88.0, self.view.width, self.view.height - 108.0)
                                                     style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.rowHeight = 64.0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self.directoryDataSource;
        [self.view addSubview:self.tableView];
        
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.width, 64.0)];
        self.searchBar.placeholder = @"Search Name";
        self.searchBar.tintColor = [UIColor whiteColor];
        self.searchBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [self.view addSubview:self.searchBar];
        self.searchBar.showsScopeBar = YES;
        self.searchBar.scopeButtonTitles = @[@"All", @"Faculty", @"Staff", @"Graduate"];
        
        self.directoryDataSource.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar
                                                                                         contentsController:self];
        self.directoryDataSource.searchDisplayController.delegate = self;
        
        self.scrollToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.scrollToTopButton.frame = CGRectMake(0.0, 0.0, self.view.width, 44.0);
        self.scrollToTopButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [self.scrollToTopButton addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.scrollToTopButton];
        
        // Menu Button
        self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
        [self.menuButton addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.menuButton];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(!self.directoryDataSource.directory) {
        self.tableView.alpha = 0.0;
        self.searchBar.alpha = 0.0;
    } else {
        self.tableView.alpha = 1.0;
        self.searchBar.alpha = 1.0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [self.directoryDataSource updateDirectoryWithCompletion:^(NSDate *updated) {
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}




- (void)didTouchDownInsideButton:(UIButton *)button
{
    if(button == self.scrollToTopButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    } else
    [self.directoryDataSource.searchDisplayController setActive:NO animated:YES];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0.0, self.tableView.y + 44.0, self.tableView.width, self.tableView.height - 44.0);
    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0.0, self.tableView.y - 44.0, self.tableView.width, self.tableView.height + 44.0);
    }];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 64.0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    self.tableView.alpha = 0.0;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    self.tableView.alpha = 1.0;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *scope = self.searchBar.scopeButtonTitles[searchOption];
        self.searchResults = [self.directoryDataSource searchDirectoryWithSearchString:self.searchBar.text scope:scope];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [controller.searchResultsTableView reloadData];
        });
    });
    
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if([searchString length] == 0) {
        self.searchResults = nil;
        return YES;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *scope = self.searchBar.scopeButtonTitles[self.searchBar.selectedScopeButtonIndex];
        self.searchResults = [self.directoryDataSource searchDirectoryWithSearchString:searchString scope:scope];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [controller.searchResultsTableView reloadData];
        });
    });
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSDirectorySearchTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    UTCSDirectoryPerson *person = self.searchResults[indexPath.row];
    cell.textLabel.text = person.fullName;
    cell.detailTextLabel.text = person.type;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

@end
