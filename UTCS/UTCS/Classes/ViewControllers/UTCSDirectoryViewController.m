//
//  UTCSDirectoryViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryViewController.h"
#import "UIColor+UTCSColors.h"
#import "FRDLivelyButton.h"
#import "UTCSSideMenuViewController.h"
#import "UIView+CZPositioning.h"

@interface UTCSDirectoryViewController ()

//
@property (strong, nonatomic) UISearchBar                   *directorySearchBar;

//
@property (strong, nonatomic) FRDLivelyButton               *menuButton;

//
@property (strong, nonatomic) UISearchDisplayController     *directorySearchDisplayController;

@end

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuButton = [[FRDLivelyButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [self.menuButton setOptions:@{kFRDLivelyButtonColor: [UIColor utcsBurntOrangeColor]}];
    [self.menuButton setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
    [self.menuButton addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.menuButton];
    
	self.directorySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, self.topLayoutGuide.length, self.view.width, 44.0)];
    self.directorySearchBar.placeholder = @"Search UTCS Directory";
    [self.view addSubview:self.directorySearchBar];
    self.directorySearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.directorySearchBar
                                                                             contentsController:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.directorySearchDisplayController setActive:YES animated:YES];
    [self.directorySearchBar becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.directorySearchDisplayController setActive:NO animated:YES];
    [self.directorySearchBar resignFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.directorySearchBar.frame = CGRectMake(0.0, self.topLayoutGuide.length, self.view.width, 44.0);
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    [self.directorySearchDisplayController setActive:NO animated:YES];
    
    if(button == self.menuButton) {
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:UTCSSideMenuDisplayNotification
                                                                                            object:self]];
    }
}

@end
