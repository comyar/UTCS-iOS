//
//  UTCSMainViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 1/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsViewController.h"

@interface UTCSEventsViewController ()
@property (strong, nonatomic) UINavigationBar       *navigationBar;
@property (strong, nonatomic) UIImageView           *UTCSLogoImageView;
@property (strong, nonatomic) UISegmentedControl    *eventCategorySegmentedControl;
@property (strong, nonatomic) UITableView           *eventsTableView;
@end

@implementation UTCSEventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Events";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeEventsTableView];
    [self initializeNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initializeNavigationBar
{
    self.navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
}



- (void)initializeEventsTableView
{
    self.eventsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 100) style:UITableViewStylePlain];
    [self.view addSubview:self.eventsTableView];
}

@end
