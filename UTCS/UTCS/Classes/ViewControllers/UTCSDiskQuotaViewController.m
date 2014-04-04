//
//  UTCSDiskQuotaViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/2/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDiskQuotaViewController.h"
#import "UTCSMenuButton.h"
#import "WMGaugeView.h"
#import "UIView+CZPositioning.h"
#import "UTCSSSHManager.h"
#import "UTCSAccountManager.h"
#import "UTCSDiskQuotaAuthenticationViewController.h"
#import "UIColor+UTCSColors.h"

@interface UTCSDiskQuotaViewController ()
@property (nonatomic) UTCSMenuButton    *menuButton;
@property (nonatomic) UIButton          *updateButton;
@property (nonatomic) UILabel           *updatedLabel;
@property (nonatomic) WMGaugeView       *gaugeView;
@property (nonatomic) UTCSDiskQuotaAuthenticationViewController *diskQuotaAuthenticationViewController;
@end

@implementation UTCSDiskQuotaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if(![UTCSAccountManager password]) {
        if(!self.diskQuotaAuthenticationViewController) {
            self.diskQuotaAuthenticationViewController = [UTCSDiskQuotaAuthenticationViewController new];
        }
        [self.navigationController pushViewController:self.diskQuotaAuthenticationViewController animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.gaugeView setValue:2000 animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
    self.menuButton.lineColor = [UIColor blackColor];
    [self.view addSubview:self.menuButton];
    
    self.gaugeView = [[WMGaugeView alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.75 * self.view.width, 0.75 * self.view.width)];
    self.gaugeView.center = self.view.center;
    self.gaugeView.backgroundColor = [UIColor clearColor];

    self.gaugeView.minValue = 0.0;
    self.gaugeView.maxValue = 2048.0;
    self.gaugeView.scaleDivisions = 8;
    self.gaugeView.scaleSubdivisions = 2;
    self.gaugeView.scaleStartAngle = 45;
    self.gaugeView.scaleEndAngle = 315;
    self.gaugeView.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    self.gaugeView.showScaleShadow = NO;
    self.gaugeView.scaleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:0.06];
    self.gaugeView.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    self.gaugeView.scaleSubdivisionsWidth = 0.002;
    self.gaugeView.scaleSubdivisionsLength = 0.04;
    self.gaugeView.scaleDivisionsWidth = 0.007;
    self.gaugeView.scaleDivisionsLength = 0.07;
    self.gaugeView.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    self.gaugeView.needleWidth = 0.012;
    self.gaugeView.needleHeight = 0.4;
    self.gaugeView.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    self.gaugeView.needleScrewRadius = 0.05;
    self.gaugeView.showUnitOfMeasurement = YES;
    self.gaugeView.unitOfMeasurement = @"MB";
    self.gaugeView.scaleDivisionColor = [UIColor utcsLightGrayColor];
    self.gaugeView.scaleSubDivisionColor = [UIColor utcsLightGrayColor];
    [self.view addSubview:self.gaugeView];
    
    self.updateButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0.0, 0.0, 0.5 * self.view.width, 44.0);
        button.center = CGPointMake(self.view.center.x, 1.6 * self.view.center.y);
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.cornerRadius = 10.0;
        [button setTitle:@"Update" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button;
    });
    [self.view addSubview:self.updateButton];
}

@end
