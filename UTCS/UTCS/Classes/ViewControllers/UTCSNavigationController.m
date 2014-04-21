//
//  UTCSNavigationController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSNavigationController.h"

@implementation UINavigationBar (Size)

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(320, 44.0);
}

@end

@implementation UTCSNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.navigationBar.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
