//
//  UTCSWelcomeViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "RQShineLabel.h"
#import "UIButton+UTCSButton.h"
#import "UTCSWelcomeViewController.h"
#import "UIView+CZPositioning.h"
#import "UTCSStateManager.h"

#pragma mark - Constants

// Font size of the welcome label
static const CGFloat welcomeLabelFontSize           = 36.0;

// Font name of the welcome label
static NSString * const welcomeLabelFontName        = @"HelveticaNeue-Bold";

// Font name of the welcome text label
static NSString * const welcomeTextLabelFontName    = @"HelveticaNeue-Light";

// Font size of the welcome label
static const CGFloat welcomeTextLabelFontSize       = 19.0;


#pragma mark - UTCSWelcomeViewController Class Extension

@interface UTCSWelcomeViewController ()

//
@property (nonatomic) RQShineLabel  *welcomeLabel;

//
@property (nonatomic) RQShineLabel  *welcomeTextLabel;

//
@property (nonatomic) UIButton      *getStartedButton;

@end


#pragma mark - UTCSWelcomeViewController Implementation

@implementation UTCSWelcomeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.welcomeLabel = ({
        RQShineLabel *label = [[RQShineLabel alloc]initWithFrame:CGRectZero];
        label.font          = [UIFont fontWithName:welcomeLabelFontName size:welcomeLabelFontSize];
        label.shadowColor   = [UIColor colorWithWhite:0.0 alpha:0.75];
        label.shadowOffset  = CGSizeMake(0.0, 1.0);
        label.textColor     = [UIColor whiteColor];
        label.text          = @"Welcome";
        label.alpha         = 0.0;
        label;
    });
    [self.view addSubview:self.welcomeLabel];
    
    self.welcomeTextLabel = ({
        RQShineLabel *label = [[RQShineLabel alloc]initWithFrame:CGRectZero];
        label.font          = [UIFont fontWithName:welcomeTextLabelFontName size:welcomeTextLabelFontSize];
        label.textColor     = [UIColor whiteColor];
        label.alpha         = 0.0;
        label.numberOfLines = 0;
        label.text          = @"The UTCS app is a collaborative mobile project between the Department of Computer Science and MAD, a student organization at the University of Texas at Austin for promoting mobile development.";
        label;
    });
    [self.view addSubview:self.welcomeTextLabel];
    
    self.getStartedButton = ({
        UIButton *button = [UIButton bouncyButton];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(16.0, 0.0, self.view.width - 32.0, 44.0);
        button.center = CGPointMake(self.view.center.x, 1.8 * self.view.center.y);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
        button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.18];
        button.layer.cornerRadius = 6.0;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Get Started" forState:UIControlStateNormal];
        button.alpha = 0.0;
        button;
    });
    [self.view addSubview:self.getStartedButton];
}

#pragma mark UIViewController Methods

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.welcomeLabel.frame     = CGRectMake(0.0, 0.0, 0.9 * CGRectGetWidth(self.view.bounds), welcomeLabelFontSize);
    self.welcomeLabel.center    = CGPointMake(self.view.center.x, 0.4 * self.view.height);
    
    CGSize welcomeTextSize = [self.welcomeTextLabel sizeThatFits:CGSizeMake(0.9 * CGRectGetWidth(self.view.bounds), CGFLOAT_MAX)];
    self.welcomeTextLabel.frame = CGRectMake(0.0, self.welcomeLabel.y + self.welcomeLabel.height + 24.0, welcomeTextSize.width, welcomeTextSize.height);
    self.welcomeTextLabel.center = CGPointMake(self.view.center.x, self.welcomeTextLabel.center.y);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.welcomeLabel shine];
    [self.welcomeTextLabel shineWithCompletion:^{
        [UIView animateWithDuration:0.6 animations:^{
            self.getStartedButton.alpha = 1.0;
        }];
    }];
    self.welcomeTextLabel.alpha = 1.0;
    self.welcomeLabel.alpha     = 1.0;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.getStartedButton) {
        [UTCSStateManager sharedManager].hasCompleteOnboarding = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.view.alpha = 0.0;
        }];
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
