//
//  UTCSNewsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsViewController.h"
#import "UTCSVerticalMenuViewController.h"

#import "FBShimmeringView.h"

#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"
#import "UIImage+ImageEffects.h"

// Constants
static NSString * const cellIdentifier              = @"UTCSNewsTableViewCell";
const NSTimeInterval kMinTimeIntervalBetweenUpdates = 3600;


#pragma mark - UTCSNewsViewController Class Extension

@interface UTCSNewsViewController ()

//
@property (assign, nonatomic) BOOL hasAppeared;

//
@property (nonatomic) UIImageView                           *backgroundImageView;

//
@property (nonatomic) UIImageView                           *blurredBackgroundImageView;

//
@property (nonatomic) FBShimmeringView                      *utcsNewsShimmeringView;

//
@property (nonatomic) UILabel                               *utcsDescriptionLabel;

//
@property (strong, nonatomic) UIButton                      *menuButton;

//
@property (strong, nonatomic) NSArray                       *newsStories;

//
@property (strong, nonatomic) NSDate                        *updateDate;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newsBackground"]];
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newsBackground-blurred"]];
    self.blurredBackgroundImageView.alpha = 0.0;
    [self.view addSubview:self.blurredBackgroundImageView];
    
    self.utcsNewsShimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    
    self.utcsNewsShimmeringView.center = CGPointMake(self.view.center.x, 0.9 * self.view.center.y);
    [self.view addSubview:self.utcsNewsShimmeringView];
    self.utcsNewsShimmeringView.contentView = ({
        UILabel *label = [[UILabel alloc]initWithFrame:self.utcsNewsShimmeringView.bounds];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
        label.text = @"UTCS News";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.25];
        label.shadowOffset = CGSizeMake(0, 1);
        label;
    });
    
    self.utcsDescriptionLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        label.numberOfLines = 0;
        label.center = CGPointMake(self.view.center.x, 1.1 * self.view.center.y);
        label.text = @"What starts here changes the world.";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        label;
    });
    [self.view addSubview:self.utcsDescriptionLabel];

    
    
    // Menu Button
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = CGRectMake(8, 8, 64, 24);
    [self.menuButton addSubview:({
        UILabel *label = [[UILabel alloc]initWithFrame:self.menuButton.frame];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        label.text = @"MENU";
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        label.shadowOffset = CGSizeMake(0, 2);
        label;
    })];
    self.menuButton.showsTouchWhenHighlighted = YES;
    [self.menuButton addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.utcsNewsShimmeringView.shimmering = YES;
    if(!self.hasAppeared) {
        self.hasAppeared = YES;
    }
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.menuButton) {
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:UTCSVerticalMenuDisplayNotification
                                                                                            object:self]];
    }
}

#pragma mark UTCSVerticalMenuViewControllerDelegate Methods

- (BOOL)shouldRecognizeVerticalMenuViewControllerPanGesture
{
    return NO;
}

@end
