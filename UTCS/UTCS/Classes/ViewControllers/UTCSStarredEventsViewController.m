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
#import "UTCSStarredEventsDataSource.h"

// Name of the background image
static NSString * const backgroundImageName         = @"eventsBackground-blurred";


@interface UTCSStarredEventsViewController ()

@property (nonatomic) UTCSStarredEventsDataSource *dataSource;

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
        self.view.backgroundColor = [UIColor clearColor];
        self.view.opaque = NO;
        self.backgroundImageView.alpha = 0.0;
        self.dataSource = [UTCSStarredEventsDataSource new];
        self.tableView.dataSource = self.dataSource;
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
    
    [self.view addSubview:({
        UIView *overlay = [[UIView alloc]initWithFrame:self.view.bounds];
        overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        overlay;
    })];
    
    [self.view addSubview:self.doneButton];
    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.doneButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.backgroundImageView.alpha = 1.0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.backgroundImageView.alpha = 0.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
