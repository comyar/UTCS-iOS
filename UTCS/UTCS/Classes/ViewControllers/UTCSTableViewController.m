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
@property (nonatomic) UIButton              *gestureButton;

//
@property (nonatomic) UIView                *navigationBarSeparatorLineView;

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
    
    self.gestureButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
        button.backgroundColor = [UIColor greenColor];
        button;
    });
    [self.view insertSubview:self.gestureButton belowSubview:self.menuButton];
    
    self.navigationBarSeparatorLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.0;
        view;
    });
    [self.view insertSubview:self.navigationBarSeparatorLineView aboveSubview:self.gestureButton];
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
    
    self.tableView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.view.bounds),
                                      CGRectGetHeight(self.view.bounds) - navigationBarHeight);
    
    self.gestureButton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), navigationBarHeight);
    [self.view insertSubview:self.gestureButton belowSubview:self.menuButton];
    
    self.navigationBarSeparatorLineView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.view.bounds), 0.5);
    [self.view bringSubviewToFront:self.navigationBarSeparatorLineView];
}

#pragma mark Buttons

- (void)didTouchDownInsideButton:(UIButton *)button
{
    NSLog(@"scroll to top");
    if (button == self.gestureButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    }
}

#pragma mark UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer locationInView:self.view].y <= CGRectGetHeight(self.navigationController.navigationBar.bounds)) {
        return YES;
    }
    return NO;
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
        _tableView.delegate         = self;
        _tableView.separatorColor   = [UIColor colorWithWhite:1.0 alpha:0.1];
        _tableView.backgroundColor  = [UIColor clearColor];
        [self.view insertSubview:_tableView belowSubview:self.gestureButton];
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
