//
//  UTCSSettingsLegalViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsLegalViewController.h"
#import "UTCSSettingsLegalDataSource.h"


@interface UTCSSettingsLegalViewController ()
@property (nonatomic) UTCSSettingsLegalDataSource *dataSource;

@end

@implementation UTCSSettingsLegalViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.menuButton.hidden = YES;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.dataSource = [UTCSSettingsLegalDataSource new];
        self.tableView.dataSource = self.dataSource;
        self.tableView.rowHeight = 50.0;
    }
    return self;
}



@end
