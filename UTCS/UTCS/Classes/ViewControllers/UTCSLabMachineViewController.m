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

- (instancetype)initWithLayout:(UTCSLabMachineViewLayout *)layout
{
    if (self = [super init]) {
        _layout = layout;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger numberOfMachines = [self.layout numberOfLabMachineViews];
    
    self.labView = [[UTCSLabView alloc]initWithFrame:CGRectMake(0.0, 44.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44.0) numberOfMachines:numberOfMachines];
    [self.view addSubview:self.labView];
}

- (void)layoutLabMachineViewsWithLabMachines:(NSArray *)labMachines
{
    NSAssert([labMachines count] <= [self.labView.machineViews count], @"Too many lab machines");
    
    self.machineMapping = [NSMutableDictionary new];
    
    long count = [labMachines count];
    for (int i = 0; i < count; ++i) {
        UTCSLabMachine *labMachine = labMachines[i];
        UTCSLabMachineView *labMachineView = self.labView.machineViews[i];
        
        labMachineView.tag = i;
        self.machineMapping[labMachine.name] = @(i);
    }
    
    for (UTCSLabMachine *labMachine in labMachines) {
        
        CGPoint position = [self.layout labMachineView:self.labView positionForLabMachine:labMachine];
        
    }
    
}

@end
