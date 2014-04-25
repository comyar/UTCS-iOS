//
//  UTCSSettingsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsViewController.h"
#import "UTCSTableViewCell.h"
#import "UTCSSettingsManager.h"
#import "UTCSSettingsDataSource.h"

@interface UTCSSettingsViewController ()

@property (nonatomic) UTCSSettingsDataSource *dataSource;

@end

@implementation UTCSSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor lightGrayColor];
        self.dataSource = [UTCSSettingsDataSource new];
        self.tableView.dataSource = self.dataSource;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = self.dataSource.sectionTitles[section];
    return ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 16.0)];
        label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        label.text = [NSString stringWithFormat:@"  %@", title];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label;
    });
}





@end
