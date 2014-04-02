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

@end


#pragma mark - UTCSMenuViewController Implementation

@implementation UTCSMenuViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.menuOptions = @[@"News", @"Events", @"Directory", @"Labs", @"Settings"];
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollsToTop = NO;
    self.tableView.rowHeight = 64;
    self.tableView.contentInset = UIEdgeInsetsMake(0.05 * CGRectGetHeight(self.view.bounds), 0, 0, 0);
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.facebookButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"facebook"]];
        button.frame = CGRectMake(self.view.width - 128, 0.6 * self.view.height, 44.0, 44.0);
        imageView.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
        button.showsTouchWhenHighlighted = YES;
        [button addSubview:imageView];
        button.alpha = 0.5;
        button;
    });
    [self.view addSubview:self.facebookButton];
    
    self.twitterButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"twitter"]];
        button.frame = CGRectMake(self.view.width - 64, 0.6 * self.view.height, 44.0, 44.0);
        imageView.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
        button.showsTouchWhenHighlighted = YES;
        [button addSubview:imageView];
        button.alpha = 0.5;
        button;
    });
    [self.view addSubview:self.twitterButton];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        self.facebookButton.alpha = 0.5;
    }
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        self.twitterButton.alpha = 0.5;
    }
    
    
}


- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.facebookButton) {
        
    } else if(button == self.twitterButton) {
        
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
        cell.textLabel.font         = [UIFont fontWithName:@"HelveticaNeue-Light" size:32];
    }
    
    cell.textLabel.textColor    = (indexPath.row == self.activeRow)? [UIColor whiteColor] : [UIColor colorWithWhite:1.0 alpha:0.5];
    cell.imageView.tintColor    = cell.textLabel.textColor;
    
    cell.textLabel.text         = self.menuOptions[indexPath.row];
    cell.imageView.image        = [[UIImage imageNamed:[cell.textLabel.text lowercaseString]]
                                   imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
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
            option = UTCSMenuOptionSettings;
        }
        [self.delegate didSelectMenuOption:option];
    }
}

@end
