//
//  UTCSLabMachineViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabMachineViewController.h"

#import "UTCSLabView.h"
#import "UTCSLabMachine.h"


@interface UTCSLabMachineViewController ()

@property (nonatomic) NSMutableDictionary *machineMapping;

@property (nonatomic) UTCSLabView *labView;

@end


@implementation UTCSLabMachineViewController

- (instancetype)initWithLayout:(UTCSLabViewLayout *)layout
{
    if (self = [super init]) {
        _layout = layout;
        _backgroundImageView = [UIImageView new];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _backgroundImageView.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:_backgroundImageView];
    
    NSInteger numberOfMachines = [self.layout numberOfLabMachineViews];
    
    self.labView = [[UTCSLabView alloc]initWithFrame:CGRectMake(0.0, 44.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44.0) numberOfMachines:numberOfMachines];
    
    [self.view addSubview:self.labView];
}

- (void)updateLabMachineViewsWithLabMachines:(NSArray *)labMachines
{
//    NSAssert([labMachines count] == [self.labView.machineViews count], @"Lab machine count doesn't equal view count");
    
    if (!_machineMapping) {
        [self buildMachineMappingWithLabMachines:labMachines];
    }
    
    for (UTCSLabMachine *labMachine in labMachines) {
        UTCSLabMachineView *labMachineView = self.machineMapping[labMachine.name];
        labMachineView.center = [self.layout labView:self.labView positionForLabMachine:labMachine];
        labMachineView.hidden = NO;
    }
}

- (void)buildMachineMappingWithLabMachines:(NSArray *)labMachines
{
    if (!labMachines) {
        return;
    }
    
    self.machineMapping = [NSMutableDictionary new];
    
    long count = [labMachines count];
    for (int i = 0; i < count; ++i) {
        UTCSLabMachine *labMachine = labMachines[i];
        UTCSLabMachineView *labMachineView = self.labView.machineViews[i];
        self.machineMapping[labMachine.name] = labMachineView;
        labMachineView.tag = i;
    }
    
}

@end
