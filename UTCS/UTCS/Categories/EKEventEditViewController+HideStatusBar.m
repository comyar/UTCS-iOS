//
//  EKEventEditViewController+HideStatusBar.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "EKEventEditViewController+HideStatusBar.h"

@implementation EKEventEditViewController (HideStatusBar)

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
