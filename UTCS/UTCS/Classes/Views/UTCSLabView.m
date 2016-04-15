/*
//
//  UTCSLabView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabView.h"
#import "UTCSLabMachineView.h"
#import "UTCSLabViewLayout.h"
#import "UTCSLabViewLayoutAttributes.h"

@interface UTCSLabView ()
@property (nonatomic) NSArray *machineViews;
@end


@implementation UTCSLabView

- (instancetype)initWithFrame:(CGRect)frame layout:(UTCSLabViewLayout *)layout
{
    if (self = [super initWithFrame:frame]) {
        _layout = layout;
        [self prepareLayout];
    }
    return self;
}

- (void)invalidateLayout
{
    [self prepareLayout];
}

- (void)prepareLayout
{
    [_layout prepareLayoutForLabView:self];
    
    for (UTCSLabMachineView *machineView in self.machineViews) {
        [machineView removeFromSuperview];
    }
    self.machineViews = nil;
    
    NSMutableArray *machineViews = [NSMutableArray new];
    
    for (int i = 0; i < _layout.numberOfLabMachines; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        UTCSLabMachineView *labMachineView = [UTCSLabMachineView new];
        labMachineView.tag = indexPath.row;
        
        [machineViews addObject:labMachineView];
    }
    
    self.machineViews = machineViews;
}

- (UTCSLabMachineView *)dequeueMachineViewForIndexPath:(NSIndexPath *)indexPath
{
    return self.machineViews[indexPath.row];
}

- (void)reloadData
{
    NSInteger count = [self.machineViews count];
    
    for (int i = 0; i < count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        NSString *machineName = [_layout labMachineNameForIndexPath:indexPath];
        UTCSLabViewLayoutAttributes *layoutAttributes = [_layout layoutAttributesForIndexPath:indexPath];
        UTCSLabMachineView *machineView = [self.dataSource labView:self machineViewForIndexPath:indexPath name:machineName];
        
        machineView.frame = CGRectMake(0.0, 0.0, layoutAttributes.size.width, layoutAttributes.size.height);
        machineView.center = layoutAttributes.center;
        machineView.tag = indexPath.row;
        
        [self addSubview:machineView];
    }
}

@end

*/