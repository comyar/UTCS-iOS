//
//  UTCSAbstractContentViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UTCSContentViewController.h"
#import "UIButton+UTCSButton.h"

#pragma mark - UTCSAbstractContentViewController Class Extension

@interface UTCSContentViewController ()

// Menu button
@property (nonatomic) UIButton *menuButton;

@end


#pragma mark - UTCSAbstractContentViewController Implementation

@implementation UTCSContentViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _backgroundImageView    = [UIImageView new];
        _menuButton             = [UIButton menuButton];
        NSLog(@"content init");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_menuButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.backgroundImageView.frame = self.view.bounds;
    NSLog(@"menu button : %@", NSStringFromCGRect(self.menuButton.bounds));
    self.menuButton.center = CGPointMake(32.0, 22.0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.menuButton];
}

- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion
{
    if ([self.dataSource shouldUpdate]) {
        [self.dataSource updateWithArgument:argument completion:completion];
    } else if (completion) {
        completion(YES, YES);
    }
}

@end
