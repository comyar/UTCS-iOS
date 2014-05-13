//
//  UTCSAuthenticationViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAuthenticationViewController.h"
#import "UIView+CZPositioning.h"
#import "UIButton+UTCSButton.h"

@interface UTCSAuthenticationViewController ()

//
@property (nonatomic) UIButton *cancelButton;

@end

@implementation UTCSAuthenticationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cancelButton = ({
        UIButton *button = [UIButton bouncyButton];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0.0, 0.0, 80.0, 28.0);
        button.center = CGPointMake(self.view.width - 51, 22);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [button setTitle:@"Cancel" forState:UIControlStateNormal];
        button.tintColor = [UIColor blackColor];
        button;
    });
    [self.view addSubview:self.cancelButton];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.cancelButton) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
