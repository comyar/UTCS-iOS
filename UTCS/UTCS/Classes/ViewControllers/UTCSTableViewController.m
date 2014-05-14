//
//  UTCSAbstractTableViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSTableViewController.h"


#pragma mark - Constants

// Height of the navigation bar separator line
static const CGFloat navigationBarSeparatorLineHeight       = 0.5;

// Maximum alpha value of the navigation bar separator line view
static const CGFloat maximumNavigationBarSeparatorLineAlpha = 0.75;

// Content offset property string used for KVO
static NSString * const contentOffsetPropertyString         = @"contentOffset";


#pragma mark - UTCSTableViewController Class Extension

@interface UTCSTableViewController ()

// Table view managed by the table view controller.
@property (nonatomic) UITableView *tableView;

// Button used to scroll table view to top.
@property (nonatomic) UIButton              *gestureButton;

// View to represent the navigation bar separator line (this should probably be a CAShapeLayer, #yolo).
@property (nonatomic) UIView                *navigationBarSeparatorLineView;

@end


#pragma mark - UTCSTableViewController Implementation

@implementation UTCSTableViewController

#pragma mark Creating a UTCSTableViewController

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
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.showsNavigationBarSeparatorLine = YES;
        
        self.gestureButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
            button;
        });
        
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:style];
            [tableView addObserver:self forKeyPath:contentOffsetPropertyString options:NSKeyValueObservingOptionNew context:nil];
            tableView.separatorColor   = [UIColor colorWithWhite:1.0 alpha:0.05];
            tableView.backgroundColor  = [UIColor clearColor];
            tableView.delegate         = self;
            tableView;
        });
        
        self.navigationBarSeparatorLineView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor whiteColor];
            view.alpha = 0.0;
            view;
        });
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view insertSubview:self.gestureButton belowSubview:self.menuButton];
    [self.view insertSubview:self.tableView     belowSubview:self.gestureButton];
    [self.view insertSubview:self.navigationBarSeparatorLineView aboveSubview:self.tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat navigationBarHeight = MAX(CGRectGetHeight(self.navigationController.navigationBar.bounds), 44.0);
    
    self.tableView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.view.bounds),
                                      CGRectGetHeight(self.view.bounds) - navigationBarHeight);
    
    self.gestureButton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), navigationBarHeight);

    self.navigationBarSeparatorLineView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.view.bounds),
                                                           navigationBarSeparatorLineHeight);
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
    
    self.navigationBarSeparatorLineView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.view.bounds),
                                                           navigationBarSeparatorLineHeight);
    [self.view bringSubviewToFront:self.navigationBarSeparatorLineView];
}

#pragma mark Buttons

- (void)didTouchDownInsideButton:(UIButton *)button
{
    if (button == self.gestureButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:YES];
    }
}

#pragma mark Key-Value Observing Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:contentOffsetPropertyString]) {
        CGFloat normalizedOffsetDelta = MAX(self.tableView.contentOffset.y / CGRectGetHeight(self.tableView.bounds), 0.0);
        self.navigationBarSeparatorLineView.alpha = (self.showsNavigationBarSeparatorLine)? MIN(maximumNavigationBarSeparatorLineAlpha,
                                                                                                normalizedOffsetDelta) : 0.0;
    }
}

#pragma mark Dealloc

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:contentOffsetPropertyString];
}

@end
