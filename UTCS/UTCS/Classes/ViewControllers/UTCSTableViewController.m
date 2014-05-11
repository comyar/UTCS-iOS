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

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _showsNavigationBarSeparatorLine = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _gestureButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
            button;
        });
        
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:style];
            tableView.delegate         = self;
            tableView.separatorColor   = [UIColor colorWithWhite:1.0
                                                           alpha:FBTweakValue(@"Table View Controller", @"Table View", @"Separator Alpha", 0.05)];
            tableView.backgroundColor  = [UIColor clearColor];
            [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            tableView;
        });
        
        _navigationBarSeparatorLineView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view.alpha = 0.0;
            view;
        });
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view insertSubview:_gestureButton belowSubview:self.menuButton];
    [self.view insertSubview:_tableView belowSubview:self.gestureButton];
    [self.view insertSubview:_navigationBarSeparatorLineView aboveSubview:self.gestureButton];
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

#pragma mark Dealloc

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
