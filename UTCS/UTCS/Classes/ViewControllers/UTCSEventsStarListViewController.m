//
//  UTCSEventsStarListViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsStarListViewController.h"
#import "UIButton+UTCSButton.h"
#import "UIImage+Cacheless.h"



// Name of the background image
static NSString * const backgroundImageName         = @"eventsBackground-blurred";


@interface UTCSEventsStarListViewController ()

@property (nonatomic) UIButton  *doneButton;

@end

@implementation UTCSEventsStarListViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.backgroundImageView.image = [UIImage cacheless_imageNamed:backgroundImageName];
        self.backgroundImageView.alpha = 1.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuButton.hidden = YES;
    
    self.doneButton = ({
        UIButton *button = [UIButton bouncyButton];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0.0, 0.0, 60.0, 28.0);
        button.center = CGPointMake(self.view.width - 41, 22);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [button setTitle:@"Done" forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
//        button.layer.masksToBounds = YES;
//        button.layer.cornerRadius = 4.0;
//        button.layer.borderWidth = 1.0;
        button;
    });
    
    [self.view addSubview:self.doneButton];
    [self.view bringSubviewToFront:self.doneButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.backgroundImageView.alpha = 1.0;
//    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.backgroundImageView.alpha = 0.0;
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.doneButton) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
