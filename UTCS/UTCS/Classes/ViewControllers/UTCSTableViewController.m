//
//  UTCSAbstractTableViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSTableViewController.h"


#pragma mark - UTCSAbstractTableViewController Class Extension

@interface UTCSTableViewController ()

@property (nonatomic) UIView *navigationBarSeparatorLineView;

@end


#pragma mark - UTCSAbstractTableViewController Implementation

@implementation UTCSTableViewController
@synthesize tableView           = _tableView;
@synthesize backgroundImageView = _backgroundImageView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _showsNavigationBarSeparatorLine = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBarSeparatorLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.0;
        view;
    });
    [self.view addSubview:self.navigationBarSeparatorLineView];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    self.navigationBarSeparatorLineView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.view.bounds), 0.5);
    [self.view bringSubviewToFront:self.navigationBarSeparatorLineView];
    
    self.tableView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - navigationBarHeight);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat normalizedOffsetDelta = MAX(self.tableView.contentOffset.y / CGRectGetHeight(self.tableView.bounds), 0.0);
        self.navigationBarSeparatorLineView.alpha = (self.showsNavigationBarSeparatorLine)? MIN(1.0, 4.0 * normalizedOffsetDelta) : 0.0;
    }
}

#pragma mark Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds
                                                 style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        [self.view insertSubview:_backgroundImageView belowSubview:_tableView];
    }
    
    return _backgroundImageView;
}

@end
