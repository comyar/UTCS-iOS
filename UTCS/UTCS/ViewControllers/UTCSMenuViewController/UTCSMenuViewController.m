//
//  UTCSMenuViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/18/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSMenuViewController.h"

#pragma mark - UTCSMenuViewController Class Extension

@interface UTCSMenuViewController ()

//
@property (strong, nonatomic) NSArray   *menuOptionNames;

//
@property (strong, nonatomic) NSArray   *menuOptionIconNames;

@property (strong, nonatomic) NSArray   *menuOptionSectionTitles;

@end


#pragma mark - UTCSMenuViewController Implementation

@implementation UTCSMenuViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.menuOptionNames = @[@[@"News", @"Events"], @[@"Labs", @"Directory"], @[@"Settings", @"About"]];
        self.menuOptionIconNames = @[@[@"news", @"events"], @[@"labs", @"directory"], @[@"settings", @"about"]];
        self.menuOptionSectionTitles = @[@"", @"", @""];
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableViewCell"];
        cell.selectionStyle         = UITableViewCellSelectionStyleNone;
        cell.backgroundColor        = [UIColor clearColor];
        cell.imageView.tintColor    = [UIColor whiteColor];
    }
    
    NSString *text              = self.menuOptionNames[indexPath.section][indexPath.row];
    NSString *imageName         = self.menuOptionIconNames[indexPath.section][indexPath.row];
    
    cell.textLabel.text         = text;
    cell.imageView.image        = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.textLabel.textColor    = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuOptionNames[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menuOptionNames count];
}

#pragma mark UITableViewDelegate Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.menuOptionSectionTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.1 * CGRectGetHeight(self.view.bounds);
    return 0.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.textColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(UTCSMenuViewControllerDelegate)] &&
       [self.delegate respondsToSelector:@selector(didSelectMenuOption:)])
    {
        UTCSMenuOptions option = -1;
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                option = UTCSMenuOptionNews;
            } else if(indexPath.row == 1) {
                option = UTCSMenuOptionEvents;
            }
        } else if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                option = UTCSMenuOptionLabs;
            } else if(indexPath.row == 1) {
                option = UTCSMenuOptionDirectory;
            } else if(indexPath.row == 2) {
                
            }
        } else if(indexPath.section == 2) {
            
        }
        [self.delegate didSelectMenuOption:option];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.alpha = 0.25;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.alpha = 1.0;
}

@end
