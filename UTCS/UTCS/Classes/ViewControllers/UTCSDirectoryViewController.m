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
#import "UTCSDirectoryManager.h"
#import "MBProgressHUD.h"

@interface UTCSDirectoryViewController ()

@property (nonatomic) UIImageView               *backgroundImageView;
@property (nonatomic) UTCSMenuButton            *menuButton;
@property (nonatomic) UITableView               *tableView;
@property (nonatomic) UISearchBar               *searchBar;
@property (nonatomic) UIButton                  *scrollToTopButton;
@property (nonatomic) UTCSDirectoryManager      *directoryManager;
@property (nonatomic) UIButton                  *syncButton;
@property (nonatomic) MBProgressHUD             *progressHUD;

@end

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.directoryManager = [UTCSDirectoryManager new];
        
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        self.backgroundImageView.image = [[UIImage imageNamed:@"directoryBackground"]applyDarkEffect];
        [self.view addSubview:self.backgroundImageView];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 88.0, self.view.width, self.view.height - 108.0)
                                                     style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.rowHeight = 64.0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self.directoryManager;
        [self.view addSubview:self.tableView];
        
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.width, 64.0)];
        self.searchBar.placeholder = @"Search Name";
        self.searchBar.tintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.searchBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [self.view addSubview:self.searchBar];
        self.searchBar.showsScopeBar = YES;
        self.searchBar.scopeButtonTitles = @[@"Faculty", @"Staff", @"Graduate"];
        
        self.directoryManager.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        self.directoryManager.searchDisplayController.delegate = self.directoryManager;
        
        self.scrollToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.scrollToTopButton.frame = CGRectMake(0.0, 0.0, self.view.width, 44.0);
        self.scrollToTopButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [self.scrollToTopButton addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.scrollToTopButton];
        
        // Menu Button
        self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
        [self.menuButton addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.menuButton];
        
        self.syncButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0.0, 0.0, 0.5 * self.view.width, 44);
            button.center = CGPointMake(self.view.center.x, 1.33 * self.view.center.y);
            [button setTitle:@"Sync Directory" forState:UIControlStateNormal];
            button.tintColor = [UIColor whiteColor];
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            button.layer.cornerRadius = 8.0;
            button.layer.masksToBounds = YES;
            button;
        });
        [self.view addSubview:self.syncButton];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(!self.directoryManager.directory) {
        self.syncButton.alpha = 1.0;
        self.tableView.alpha = 0.0;
        self.searchBar.alpha = 0.0;
    } else {
        self.syncButton.alpha = 0.0;
        self.tableView.alpha = 1.0;
        self.searchBar.alpha = 1.0;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressHUD = ({
        MBProgressHUD *progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = @"Syncing...";
        progressHUD;
    });
}

- (void)didTouchDownInsideButton:(UIButton *)button
{
    if(button == self.scrollToTopButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    } else
    [self.directoryManager.searchDisplayController setActive:NO animated:YES];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.syncButton) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self.directoryManager syncDirectoryWithCompletion:^(BOOL success) {
                if(success) {
                    [self.tableView reloadData];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.alpha = (success)? 1.0 : 0.0;
                        self.syncButton.alpha = (success)? 0.0 : 1.0;
                        self.searchBar.alpha = (success)? 1.0 : 0.0;
                    }];
                });
            }];
        });
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




@end
