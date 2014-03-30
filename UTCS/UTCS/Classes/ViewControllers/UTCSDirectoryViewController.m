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
#import "UTCSSearchBar.h"

@interface UTCSDirectoryViewController ()
@property (nonatomic) UIImageView       *backgroundImageView;
@property (nonatomic) UTCSMenuButton    *menuButton;
@property (nonatomic) UITableView       *tableView;
@property (nonatomic) UTCSSearchBar       *searchBar;

@end

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor redColor];
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
    self.backgroundImageView.image = [[UIImage imageNamed:@"directoryBackground"]tintedImageWithColor:[UIColor utcsImageTintColor] blendingMode:kCGBlendModeOverlay];
    [self.view addSubview:self.backgroundImageView];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(8, 28, 56, 32)];
    [self.view addSubview:self.menuButton];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 128.0, self.view.width, self.view.height - 64.0)
                                                 style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 64.0;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.searchBar = [[UTCSSearchBar alloc]initWithFrame:CGRectMake(0.0, 64.0, self.view.width, 64.0)];
    self.searchBar.searchField.placeholder = @"Search UTCS Directory";
    [self.view addSubview:self.searchBar];
    
    
}

@end
