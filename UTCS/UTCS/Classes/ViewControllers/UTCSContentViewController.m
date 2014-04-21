//
//  UTCSAbstractContentViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UTCSContentViewController.h"
#import "UTCSMenuButton.h"


#pragma mark - UTCSAbstractContentViewController Class Extension

@interface UTCSContentViewController ()

// Menu button
@property (nonatomic) UTCSMenuButton *menuButton;

@end


#pragma mark - UTCSAbstractContentViewController Implementation

@implementation UTCSContentViewController

+ (NSDictionary *)serviceStackConfiguration
{
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(-16.0, 0.0, 76.0, 36.0)];
    UIView *menuButtonContainer = [[UIView alloc]initWithFrame:self.menuButton.bounds];
    [menuButtonContainer addSubview:self.menuButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuButtonContainer];
}

- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion
{
    if ([self.dataSource shouldUpdate]) {
        [self.dataSource updateWithArgument:argument completion:completion];
    }
}


@end
