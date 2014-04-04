//
//  UTCSMenuViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/18/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSMenuViewController.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"

#pragma mark - UTCSMenuViewController Class Extension

@interface UTCSMenuViewController ()

//
@property (strong, nonatomic) NSArray   *menuOptions;

@property (nonatomic) NSInteger         activeRow;

@property (nonatomic) UIButton          *facebookButton;

@property (nonatomic) UIButton          *twitterButton;

@property (nonatomic) UIButton          *notificationsButton;

@property (nonatomic) UITableView       *tableView;

@end


#pragma mark - UTCSMenuViewController Implementation

@implementation UTCSMenuViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.menuOptions = @[@"News", @"Events", @"Directory", @"Labs", @"Disk Quota", @"Settings"];
        self.title = @"Menu";
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.75 * self.view.width, self.view.height)
                                                     style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 60;
        self.tableView.contentInset = UIEdgeInsetsMake(0.05 * self.view.height, 0, 0, 0);
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.width = 0.75 * self.view.width;
        [self.view addSubview:self.tableView];
        
        self.twitterButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(self.view.width - 44.0, 0.75 * self.view.height, 44.0, 44.0);
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"twitter"]];
            imageView.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
            imageView.center = CGPointMake(0.5 * button.width, 0.5 * button.height);
            button.showsTouchWhenHighlighted = YES;
            [button addSubview:imageView];
            button.alpha = 0.5;
            button;
        });
        [self.view addSubview:self.twitterButton];
        
        self.facebookButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(self.view.width - 88.0, 0.75 * self.view.height, 44.0, 44.0);
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"facebook"]];
            imageView.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
            imageView.center = CGPointMake(0.5 * button.width, 0.5 * button.height);
            button.showsTouchWhenHighlighted = YES;
            [button addSubview:imageView];
            button.alpha = 0.5;
            button;
        });
        [self.view addSubview:self.facebookButton];
        
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=UTCompSci"]]) {
        self.twitterButton.alpha = 0.5;
        self.twitterButton.centerY = self.notificationsButton.centerY + self.twitterButton.height;
        self.facebookButton.centerY = self.twitterButton.centerY + self.facebookButton.height;
    } else {
//        self.facebookButton.centerY = self.notificationsButton.centerY + self.facebookButton.height;
    }
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"fb://profile/272565539464226"]]) {
        self.facebookButton.alpha = 0.5;
    }
    
   
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.facebookButton) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"fb://profile/272565539464226"]];
    } else if(button == self.twitterButton) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"twitter://user?screen_name=UTCompSci"]];
    }
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
        cell.textLabel.font         = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    }
    
    cell.textLabel.textColor    = (indexPath.row == self.activeRow)? [UIColor whiteColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
    cell.imageView.tintColor    = cell.textLabel.textColor;
    
    cell.textLabel.text         = self.menuOptions[indexPath.row];
    NSString *imageName         = [[cell.textLabel.text lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    cell.imageView.image        = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuOptions count];
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.activeRow = indexPath.row;
    [self.tableView reloadData];
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(UTCSMenuViewControllerDelegate)] &&
       [self.delegate respondsToSelector:@selector(didSelectMenuOption:)])
    {
        UTCSMenuOptions option = -1;
        if(indexPath.row == 0) {
            option = UTCSMenuOptionNews;
        } else if(indexPath.row == 1) {
            option = UTCSMenuOptionEvents;
        } else if(indexPath.row == 2) {
            option = UTCSMenuOptionDirectory;
        } else if(indexPath.row == 3) {
            option = UTCSMenuOptionLabs;
        } else if(indexPath.row == 4) {
            option = UTCSMenuOptionDiskQuota;
        } else if(indexPath.row == 5) {
            option = UTCSMenuOptionSettings;
        }
        [self.delegate didSelectMenuOption:option];
    }
}

@end
