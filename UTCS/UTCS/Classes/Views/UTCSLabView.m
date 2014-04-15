//
//  UTCSLabView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabView.h"
#import "UTCSLabMachineView.h"

@interface UTCSLabView ()

@property (nonatomic) NSMutableDictionary *labMachineViews;

@end

@implementation UTCSLabView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.labMachineViews = [NSMutableDictionary new];
    }
    return self;
}

- (UTCSLabMachineView *)dequeueLabMachineWithIdentifier:(NSString *)identifier
{
    UTCSLabMachineView *labMachineView = self.labMachineViews[identifier];
    if(!labMachineView) {
        labMachineView = [[UTCSLabMachineView alloc]initWithFrame:CGRectMake(0.0, 0.0, 16.0, 16.0) identifier:identifier];
        self.labMachineViews[identifier] = labMachineView;
    }
    
    return labMachineView;
}

- (void)setDataSource:(id<UTCSLabViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData
{
    NSArray *identifiers = [self.dataSource labMachineViewIdentifiers];
    for(NSString *identifier  in identifiers) {
        UTCSLabMachineView *labMachineView = [self.dataSource labMachineViewForIdentifier:identifier];
        [self addSubview:labMachineView];
    }
}

@end
