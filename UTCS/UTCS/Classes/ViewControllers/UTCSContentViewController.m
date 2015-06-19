//
//  UTCSAbstractContentViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UIButton+UTCSButton.h"
#import "UTCSContentViewController.h"


#pragma mark - UTCSAbstractContentViewController Class Extension

@interface UTCSContentViewController ()

// Button that shows the menu.
@property (nonatomic) UIButton      *menuButton;

// Image view for displaying a background image
@property (nonatomic) UIImageView   *backgroundImageView;

@end


#pragma mark - UTCSAbstractContentViewController Implementation

@implementation UTCSContentViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"";  // Hides the word 'Back' in a navigation controller's back button
        
        self.menuButton = [UIButton menuButton];
        
        self.backgroundImageView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.menuButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.backgroundImageView.frame = self.view.bounds;
    self.menuButton.center = CGPointMake(33.0, 22.0);
    [self.view bringSubviewToFront:self.menuButton];
    [self.view sendSubviewToBack:self.backgroundImageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.menuButton];
}

@end
