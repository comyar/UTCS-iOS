//
//  UTCSAbstractTableViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAbstractTableViewController.h"


#pragma mark - UTCSAbstractTableViewController Class Extension

@interface UTCSAbstractTableViewController ()

//
@property (nonatomic) UITableView   *tableView;

//
@property (nonatomic) UIButton      *scrollToTopButton;

//
@property (nonatomic) UIImageView   *backgroundImageView;

@end


#pragma mark - UTCSAbstractTableViewController Implementation

@implementation UTCSAbstractTableViewController

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds
                                                             style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor blackColor];
        tableView;
    });
    
    [self.view addSubview:_tableView];
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
