//
//  UTCSNavigationControllerDelegate.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;
@class UTCSNavigationController;

@interface UTCSNavigationControllerDelegate : NSObject <UINavigationControllerDelegate>

@property (weak, nonatomic) UTCSNavigationController *navigationController;

@end
