//
//  UTCSButton.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/11/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTCSButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame;
- (void)didDragExit;
- (void)didTouchDown;
- (void)didTouchUpInside;

@end
