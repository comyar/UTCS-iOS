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

@interface UTCSDiskQuotaViewController ()
@property (nonatomic) UTCSMenuButton    *menuButton;
@property (nonatomic) WMGaugeView       *gaugeView;
@end

@implementation UTCSDiskQuotaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

    self.gaugeView.maxValue = 100.0;
    self.gaugeView.scaleDivisions = 10;
    self.gaugeView.scaleSubdivisions = 5;
    self.gaugeView.scaleStartAngle = 30;
    self.gaugeView.scaleEndAngle = 280;
    self.gaugeView.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    self.gaugeView.showScaleShadow = NO;
    self.gaugeView.scaleFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:0.065];
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
    [self.view addSubview:self.gaugeView];
}

@end
