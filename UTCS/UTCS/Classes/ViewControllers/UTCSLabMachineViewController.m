//
//  UTCSLabMachineViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabMachineViewController.h"
#import "UTCSLabViewLayoutAttributes.h"
#import "UTCSLabMachineView.h"
#import "UTCSLabMachine.h"
#import "UTCSLabView.h"


@interface UTCSLabMachineViewController ()

@property (nonatomic) UTCSLabView      *labView;

@end


@implementation UTCSLabMachineViewController

- (instancetype)initWithLayout:(UTCSLabViewLayout *)layout
{
    if (self = [super init]) {
        _layout = layout;
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuButton.hidden = YES;
    
    self.labView = [[UTCSLabView alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.width, self.view.height - 44.0) layout:self.layout];
    self.labView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.labView];
}

- (void)setMachines:(NSArray *)machines
{
    _machines = machines;
    
    for (UTCSLabMachine *machine in _machines) {
        UTCSLabViewLayoutAttributes *layoutAttributes = [_layout layoutAttributesForLabMachineName:machine.name];
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        UTCSLabMachineView *labMachineView = (UTCSLabMachineView *)self.labView.machineViews[indexPath.row];
        if (machine.occupied) {
            labMachineView.backgroundColor = [UIColor redColor];
        } else {
            labMachineView.backgroundColor = [UIColor greenColor];
        }
    }
    
}


@end
