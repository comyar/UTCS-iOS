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

@end


#pragma mark - UTCSAbstractTableViewController Implementation

@implementation UTCSTableViewController
@synthesize tableView           = _tableView;
@synthesize backgroundImageView = _backgroundImageView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
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
