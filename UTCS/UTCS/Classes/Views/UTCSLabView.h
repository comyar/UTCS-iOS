/*
//
//  UTCSLabView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;
@class UTCSLabView;

#import "UTCSLabViewLayout.h"
#import "UTCSLabMachineView.h"


@protocol UTCSLabViewDataSource <NSObject>

- (UTCSLabMachineView *)labView:(UTCSLabView *)labView machineViewForIndexPath:(NSIndexPath *)indexPath name:(NSString *)name;

@end


@interface UTCSLabView : UIView

- (instancetype)initWithFrame:(CGRect)frame layout:(UTCSLabViewLayout *)layout;
- (UTCSLabMachineView *)dequeueMachineViewForIndexPath:(NSIndexPath *)indexPath;
- (void)prepareLayout;
- (void)invalidateLayout;
- (void)reloadData;


@property (nonatomic, readonly) UTCSLabViewLayout   *layout;
@property (nonatomic) id<UTCSLabViewDataSource>     dataSource;

@end
