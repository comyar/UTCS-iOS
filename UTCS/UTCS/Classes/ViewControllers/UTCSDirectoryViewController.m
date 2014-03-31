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

@interface UTCSDirectoryViewController ()
@property (nonatomic) UIImageView       *backgroundImageView;
@property (nonatomic) UTCSMenuButton    *menuButton;
@property (nonatomic) UITableView       *tableView;
@property (nonatomic) UISearchBar       *searchBar;
@property (nonatomic) UIButton          *scrollToTopButton;
@property (nonatomic) UTCSDirectoryManager  *directoryManager;
@property (nonatomic) UISearchDisplayController *directorySearchDisplayController;

@end

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.directoryManager = [UTCSDirectoryManager new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.searchBar.placeholder = @"Search Directory";
    self.searchBar.tintColor = [UIColor lightGrayColor];
    self.searchBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [self.view addSubview:self.searchBar];
    
    self.directorySearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    
    self.scrollToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.scrollToTopButton.frame = CGRectMake(0.0, 0.0, self.view.width, 44.0);
    self.scrollToTopButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [self.scrollToTopButton addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.scrollToTopButton];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(8, 8, 56, 32)];
    [self.menuButton addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.menuButton];
    
    [self.directoryManager syncDirectoryWithCompletion:^(BOOL success) {
        [self.tableView reloadData];
    }];
}

- (void)didTouchDownInsideButton:(UIButton *)button
{
    if(button == self.scrollToTopButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    }
    [self.directorySearchDisplayController setActive:NO animated:YES];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

@end
