//
//  UTCSLabMachineViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabMachineViewController.h"
#import "UTCSLabMachine.h"


@interface UTCSLabMachineViewController ()

@property (nonatomic) UTCSLabView      *labView;

@end


@implementation UTCSLabMachineViewController

- (instancetype)initWithLayout:(UTCSLabViewLayout *)layout
{
    if (self = [super init]) {
        _layout = layout;
        self.labView = [[UTCSLabView alloc]initWithFrame:CGRectZero layout:self.layout];
        self.labView.frame = CGRectMake(0.0, 44.0, self.view.width, self.view.height - 44.0);
        self.labView.backgroundColor = [UIColor clearColor];
        self.labView.dataSource = self;
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.labView invalidateLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuButton.hidden = YES;
    
    [self.labView prepareLayout];
    [self.view addSubview:self.labView];
    
}

- (void)setMachines:(NSDictionary *)machines
{
    _machines = machines;
    [self.labView invalidateLayout];
    [self.labView reloadData];
}

#pragma mark UTCSLabViewDataSource Methods

- (UTCSLabMachineView *)labView:(UTCSLabView *)labView machineViewForIndexPath:(NSIndexPath *)indexPath name:(NSString *)name
{
    UTCSLabMachineView *machineView = [labView dequeueMachineViewForIndexPath:indexPath];
    if (!name) {
        machineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    } else {
        UTCSLabMachine *machine = self.machines[name];
        if (machine.occupied) {
            machineView.backgroundColor = [UIColor redColor];
        } else {
            machineView.backgroundColor = [UIColor greenColor];
        }
    }
    return machineView;
}

@end
