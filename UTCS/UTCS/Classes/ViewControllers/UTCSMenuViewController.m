//
//  UTCSMenuViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/18/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSMenuViewController.h"
#import "UIColor+UTCSColors.h"

#pragma mark - UTCSMenuViewController Class Extension

@interface UTCSMenuViewController ()

//
@property (strong, nonatomic) NSArray   *menuOptions;

@end


#pragma mark - UTCSMenuViewController Implementation

@implementation UTCSMenuViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.menuOptions = @[@"News", @"Events", @"Directory", @"Labs", @"About"];
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 50;
    self.tableView.contentInset = UIEdgeInsetsMake(0.15 * CGRectGetHeight(self.view.bounds), 0, 0, 0);
    self.tableView.backgroundColor = [UIColor utcsDarkGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableViewCell"];
        cell.selectionStyle         = UITableViewCellSelectionStyleNone;
        cell.backgroundColor        = [UIColor clearColor];
        cell.textLabel.textColor    = [UIColor colorWithWhite:1.0 alpha:0.8];
        cell.textLabel.font         = [UIFont fontWithName:@"HelveticaNeue-Light" size:32];
    }
    
    cell.textLabel.text         = self.menuOptions[indexPath.row];
    cell.imageView.image        = [[UIImage imageNamed:[cell.textLabel.text lowercaseString]]
                                   imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.imageView.tintColor    = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuOptions count];
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(UTCSMenuViewControllerDelegate)] &&
       [self.delegate respondsToSelector:@selector(didSelectMenuOption:)])
    {
        UTCSMenuOptions option = -1;
        if(indexPath.row == 0) {
            option = UTCSMenuOptionNews;
        } else if(indexPath.row == 1) {
            option = UTCSMenuOptionEvents;
        } else if(indexPath.row == 2) {
            option = UTCSMenuOptionLabs;
        } else if(indexPath.row == 3) {
            option = UTCSMenuOptionDirectory;
        } else if(indexPath.row == 4) {
            
        }
        [self.delegate didSelectMenuOption:option];
    }
}

@end
