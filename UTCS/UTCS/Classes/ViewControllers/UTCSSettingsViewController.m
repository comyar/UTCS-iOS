//
//  UTCSSettingsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsViewController.h"
#import "UTCSBouncyTableViewCell.h"
#import "UTCSStateManager.h"
#import "UTCSSettingsDataSource.h"
#import "UTCSSettingsLegalViewController.h"
#import "UTCSSettingsAboutViewController.h"


@interface UTCSSettingsViewController ()

@property (nonatomic) UTCSSettingsDataSource            *dataSource;

@property (nonatomic) UTCSSettingsLegalViewController   *legalViewController;

@property (nonatomic) UTCSSettingsAboutViewController   *aboutViewController;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.legalViewController = nil;
    self.aboutViewController = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (!self.legalViewController) {
                self.legalViewController = [UTCSSettingsLegalViewController new];
            }
            [self.navigationController pushViewController:self.legalViewController animated:YES];
        } else if (indexPath.row == 1) {
            if (!self.aboutViewController) {
                self.aboutViewController = [UTCSSettingsAboutViewController new];
            }
            [self.navigationController pushViewController:self.aboutViewController animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            return 64.0;
        } else if(indexPath.row == 1) {
            return 80.0;
        }
    }
    
    return 50.0;
}


@end
