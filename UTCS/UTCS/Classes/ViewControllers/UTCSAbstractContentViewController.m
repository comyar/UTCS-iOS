//
//  UTCSAbstractContentViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UTCSAbstractContentViewController.h"
#import "UTCSAbstractDataSource.h"
#import "UTCSMenuButton.h"


#pragma mark - UTCSAbstractContentViewController Class Extension

@interface UTCSAbstractContentViewController ()

// Menu button
@property (nonatomic) UTCSMenuButton *menuButton;

@end


#pragma mark - UTCSAbstractContentViewController Implementation

@implementation UTCSAbstractContentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 76.0, 36.0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.menuButton];
}



- (void)updateWithArgument:(NSString *)argument
{
    if ([self.dataSource shouldUpdate]) {
        [self.dataSource updateWithArgument:argument completion:^(id values, NSError *error) {
            if (values) {
                
            } else {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}


@end
