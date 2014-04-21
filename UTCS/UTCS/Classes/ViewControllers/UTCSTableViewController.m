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

//
@property (nonatomic) UIView *gestureBar;

//
@property (nonatomic) UIView *navigationBarSeparatorLineView;

//
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

//
@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

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
    self.gestureBar = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    [self.view addSubview:self.gestureBar];
    
    self.tapGestureRecognizer = ({
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                           action:@selector(didRecognizerTapGesture:)];
        gestureRecognizer.numberOfTapsRequired      = 1;
        gestureRecognizer.numberOfTouchesRequired   = 1;
        gestureRecognizer;
    });
    [self.gestureBar addGestureRecognizer:self.tapGestureRecognizer];
    
    self.navigationBarSeparatorLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.0;
        view;
    });
    [self.view addSubview:self.navigationBarSeparatorLineView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    
    self.gestureBar.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), navigationBarHeight);
    [self.view insertSubview:self.gestureBar belowSubview:self.menuButton];
    
    self.navigationBarSeparatorLineView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.view.bounds), 0.5);
    [self.view bringSubviewToFront:self.navigationBarSeparatorLineView];
    
    self.tableView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - navigationBarHeight);
    self.tableView.tableHeaderView.frame = self.tableView.bounds;
}

#pragma mark Gesture Recognizer Methods

- (void)didRecognizerTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.tapGestureRecognizer) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    }
}

#pragma mark Key-Value Observing Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat normalizedOffsetDelta = MAX(self.tableView.contentOffset.y / CGRectGetHeight(self.tableView.bounds), 0.0);
        self.navigationBarSeparatorLineView.alpha = (self.showsNavigationBarSeparatorLine)? MIN(0.5, normalizedOffsetDelta) : 0.0;
    }
}

#pragma mark Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds
                                                 style:UITableViewStylePlain];
        _tableView.separatorColor   = [UIColor colorWithWhite:1.0 alpha:0.1];
        _tableView.backgroundColor  = [UIColor clearColor];
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
