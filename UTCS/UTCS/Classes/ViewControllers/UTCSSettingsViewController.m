//
//  UTCSSettingsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

// View Controllers
#import "UTCSSettingsViewController.h"

// Views
#import "UTCSMenuButton.h"


#pragma mark - UTCSSetttingsViewController Class Extension

@interface UTCSSettingsViewController ()

//
@property (nonatomic) UTCSMenuButton *menuButton;

@end


#pragma mark - UTCSSetttingsViewController Implementation

@implementation UTCSSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Menu Button
    self.menuButton = ({
        UTCSMenuButton *button = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
        button.lineColor = [UIColor blackColor];
        [self.view addSubview:button];
        button;
    });
}

@end
