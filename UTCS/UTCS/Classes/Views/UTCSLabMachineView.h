//
//  UTCSLabMachineView.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTCSLabMachineView : UIView

- (instancetype)initWithFrame:(CGRect)frame identifier:(NSString *)identifier;

@property (nonatomic, readonly) NSString *identifier;

@end
