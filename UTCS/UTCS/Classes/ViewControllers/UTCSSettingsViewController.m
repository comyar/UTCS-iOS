//
//  UTCSSettingsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsViewController.h"
#import "UIImage+CZTinting.h"
#import "UTCSMenuButton.h"
#import "UIView+CZPositioning.h"
#import "UTCSAboutViewController.h"
#import "UTCSLicenseViewController.h"

@interface UTCSSettingsViewController ()

// Button used to display the menu view controller
@property (nonatomic) UTCSMenuButton            *menuButton;

// Image view used to display the background image
@property (nonatomic) UIImageView               *backgroundImageView;

@property (nonatomic) UIButton          *facebookButton;

@property (nonatomic) UIButton          *twitterButton;

@property (nonatomic) UITableView       *tableView;

@property (nonatomic) NSArray           *settings;

@property (nonatomic) NSArray           *headers;

@property (nonatomic) UTCSAboutViewController   *aboutViewController;
@property (nonatomic) UTCSLicenseViewController *licenseViewController;

@end

@implementation UTCSSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Settings";
        self.headers = @[@"App Info", @"Account"];
        self.settings = @[@[@"About", @"Legal"], @[@"Logout"]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=UTCompSci"]]) {
        self.twitterButton.alpha = 0.5;
        self.facebookButton.centerY = self.twitterButton.centerY + self.facebookButton.height;
    } else {
        //        self.facebookButton.centerY = self.notificationsButton.centerY + self.facebookButton.height;
    }
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"fb://profile/272565539464226"]]) {
        self.facebookButton.alpha = 0.5;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.0;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // Background image view
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"diskQuotaBackground"]tintedImageWithColor:[UIColor colorWithWhite:0.11 alpha:0.73] blendingMode:kCGBlendModeOverlay]];
        imageView;
    });
    
    [self.navigationController.view insertSubview:self.backgroundImageView atIndex:0];
    
    // Menu Button
    self.menuButton = ({
        UTCSMenuButton *button = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
        button.lineColor = [UIColor whiteColor];
        [self.view addSubview:button];
        button;
    });
    
    self.twitterButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(self.view.width - 44.0, 0.9 * self.view.height, 44.0, 44.0);
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
        button.frame = CGRectMake(self.view.width - 88.0, 0.9 * self.view.height, 44.0, 44.0);
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
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.width, self.view.height - 44.0)
                                                             style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UTCSSettingsTableViewCell"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *separator = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.05 * cell.width, cell.height - 1, 0.9 * cell.width, 0.75)];
            view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
            view;
        });
        [cell.contentView addSubview:separator];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    cell.selected = NO;
    cell.textLabel.text = self.settings[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settings[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.view.width, 24)];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label.text = [NSString stringWithFormat:@"  %@", self.headers[section]];
        [view addSubview:label];
        view;
    });
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.settings count];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.facebookButton) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"fb://profile/272565539464226"]];
    } else if(button == self.twitterButton) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"twitter://user?screen_name=UTCompSci"]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            if(!self.aboutViewController) {
                self.aboutViewController = [UTCSAboutViewController new];
            }
            [self.navigationController pushViewController:self.aboutViewController animated:YES];
        } else if(indexPath.row == 1) {
            if(!self.licenseViewController) {
                self.licenseViewController = [UTCSLicenseViewController new];
            }
            
            [self.navigationController pushViewController:self.licenseViewController animated:YES];
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            [[[UIAlertView alloc]initWithTitle:@"Logout"
                                       message:@"Are you sure you want to logout?"
                                      delegate:nil
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@"Yes", nil]show];
        }
    }
}

@end
