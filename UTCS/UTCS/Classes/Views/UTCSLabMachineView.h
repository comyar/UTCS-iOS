//
//  UTCSLabMachineView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSButton.h"

@class UTCSLabMachineView;


@protocol UTCSLabMachineViewDelegate <NSObject>

@optional
- (void)didTouchUpInsideLabMachineView:(UTCSLabMachineView *)labMachineView;

@end


@interface UTCSLabMachineView : UTCSButton

@property (nonatomic) id<UTCSLabMachineViewDelegate> delegate;

@end
