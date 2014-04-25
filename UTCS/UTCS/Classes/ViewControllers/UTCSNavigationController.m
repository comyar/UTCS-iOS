//
//  UTCSNavigationController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSNavigationController.h"
#import "UTCSNavigationControllerDelegate.h"




@implementation UINavigationController (Retro)


@end

@interface UTCSNavigationController ()

@property (nonatomic) UTCSNavigationControllerDelegate *navigationDelegate;

@end


@implementation UTCSNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.navigationDelegate = [UTCSNavigationControllerDelegate new];
        self.delegate = self.navigationDelegate;
        self.navigationDelegate.navigationController = self;

        _backgroundImageView = [UIImageView new];
        [self.view addSubview:self.backgroundImageView];
        [self.view sendSubviewToBack:self.backgroundImageView];
    }
    return self;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.backgroundImageView.frame = self.view.bounds;
}


@end
