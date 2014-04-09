//
//  UTCSLabsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsViewController.h"
#import "UTCSMenuButton.h"
#import "UIImage+ImageEffects.h"
#import "MBProgressHUD.h"
#import "UTCSSSHManager.h"
#import "UIView+CZPositioning.h"
#import "UTCSLabsManager.h"

@interface UTCSLabsViewController ()
@property (nonatomic) UIImageView               *backgroundImageView;
@property (nonatomic) UTCSMenuButton            *menuButton;
@property (nonatomic) UITableView               *tableView;
@property (nonatomic) UISearchBar               *searchBar;
@property (nonatomic) UIButton                  *scrollToTopButton;
@property (nonatomic) UTCSLabsManager           *labsManager;
@end

@implementation UTCSLabsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.labsManager = [UTCSLabsManager new];
        
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 88.0, self.view.width, self.view.height - 108.0)
                                                     style:UITableViewStylePlain];
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.rowHeight = 64.0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self.labsManager;
        self.tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        [self.view addSubview:self.tableView];
        
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.width, 64.0)];
        self.searchBar.placeholder = @"Unix Host Name";
        self.searchBar.tintColor = [UIColor whiteColor];
        self.searchBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [self.view addSubview:self.searchBar];
        self.searchBar.showsScopeBar = YES;
        self.searchBar.scopeButtonTitles = @[@"Third Floor", @"Basement"];
        
        self.labsManager.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        self.labsManager.searchDisplayController.delegate = self;
        
        self.scrollToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.scrollToTopButton.frame = CGRectMake(0.0, 0.0, self.view.width, 44.0);
        self.scrollToTopButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [self.scrollToTopButton addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.scrollToTopButton];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.backgroundImageView.image = [[UIImage imageNamed:@"menuBackground"]applyDarkEffect];
    [self.view addSubview:self.backgroundImageView];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
    [self.view addSubview:self.menuButton];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{

}

- (void)didTouchDownInsideButton:(UIButton *)button
{
    if(button == self.scrollToTopButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    } else {
        [self.labsManager.searchDisplayController setActive:NO animated:YES];
    }
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
    tableView.backgroundColor = [UIColor clearColor];
    self.tableView.alpha = 0.0;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    self.tableView.alpha = 1.0;
}


@end
