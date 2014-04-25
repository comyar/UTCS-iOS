//
//  UTCSSettingsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsViewController.h"
#import "UTCSBouncyTableViewCell.h"
#import "UTCSSettingsManager.h"
#import "UTCSSettingsDataSource.h"

@interface UTCSSettingsViewController ()

@property (nonatomic) UTCSSettingsDataSource    *dataSource;

@end

@implementation UTCSSettingsViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.backgroundImageView.image = [UIImage imageNamed:@"settingsBackground"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 64.0;
    }
    
    return 50;
}


@end
