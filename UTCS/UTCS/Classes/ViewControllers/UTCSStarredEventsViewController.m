//
//  UTCSEventsStarListViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSStarredEventsViewController.h"
#import "UIButton+UTCSButton.h"
#import "UTCSStarredEventManager.h"

// Name of the background image
static NSString * const backgroundImageName         = @"eventsBackground-blurred";


@interface UTCSStarredEventsViewController ()

@property (nonatomic) UIButton  *doneButton;

@end

@implementation UTCSStarredEventsViewController

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
//        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.backgroundImageView.alpha = 0.0;
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
        button;
    });
    
    UIView *overlay = [[UIView alloc]initWithFrame:self.view.bounds];
    overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:overlay];
    
    [self.view addSubview:self.doneButton];
    [self.view bringSubviewToFront:self.doneButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.backgroundImageView.alpha = 1.0;
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.backgroundImageView.alpha = 0.0;
    [super viewWillDisappear:animated];
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
