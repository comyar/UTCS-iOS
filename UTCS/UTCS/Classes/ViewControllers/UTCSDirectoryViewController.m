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

@interface UTCSDirectoryViewController ()
@property (nonatomic) UIImageView       *backgroundImageView;
@property (nonatomic) UTCSMenuButton    *menuButton;
@property (nonatomic) UITableView       *tableView;
@property (nonatomic) UISearchBar       *searchBar;
@property (nonatomic) NSArray           *fillerData;

@end

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor redColor];
        self.fillerData = @[@[@"Comyar Zaheri", @"Undergraduate"],
                            @[@"Henri Sweers", @"Undergradute"],
                            @[@"Brent Winkelman", @"Staff"],
                            @[@"Paul Toprac", @"Faculty"]];
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
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 108.0, self.view.width, self.view.height - 64.0)
                                                 style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 64.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.width, 64.0)];
    self.searchBar.placeholder = @"Search Directory";
    self.searchBar.tintColor = [UIColor utcsBurntOrangeColor];
    self.searchBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [self.view addSubview:self.searchBar];
    
    UIView *pseudoNavigationBar = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 44.0)];
    pseudoNavigationBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [self.view addSubview:pseudoNavigationBar];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(8, 8, 56, 32)];
    [self.view addSubview:self.menuButton];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSDirectoryTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSDirectoryTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = self.fillerData[indexPath.row][0];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.text = self.fillerData[indexPath.row][1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fillerData count];
}

@end
