//
//  UTCSAbstractContentViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UTCSAbstractContentViewController.h"
#import "UTCSAbstractDataSource.h"


#pragma mark - UTCSAbstractContentViewController Implementation

@implementation UTCSAbstractContentViewController

- (void)updateWithArgument:(NSString *)argument
{
    if ([self.dataSource shouldUpdate]) {
        [self.dataSource updateWithArgument:argument completion:^(id values, NSError *error) {
            if (values) {
                
            } else {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}


@end
