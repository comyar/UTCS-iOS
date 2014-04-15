//
//  UTCSLabView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UTCSLabView;
@class UTCSLabMachineView;

@protocol UTCSLabViewDataSource <NSObject>

- (NSArray *)labMachineViewIdentifiersForLabView:(UTCSLabView *)labView;
- (UTCSLabMachineView *)labView:(UTCSLabView *)labView labMachineViewForIdentifier:(NSString *)identifier;

@end


@interface UTCSLabView : UIView

- (UTCSLabMachineView *)dequeueLabMachineWithIdentifier:(NSString *)identifier;
- (void)reloadData;

@property (nonatomic) id<UTCSLabViewDataSource> dataSource;

@end
