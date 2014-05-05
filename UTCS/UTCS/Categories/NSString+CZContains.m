//
//  NSString+CZContains.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "NSString+CZContains.h"

@implementation NSString (CZContains)

- (BOOL)contains:(NSString *)substring
{
    return [self contains:substring caseSensitive:NO];
}

- (BOOL)contains:(NSString *)substring caseSensitive:(BOOL)caseSensitive
{
    NSUInteger index = NSNotFound;
    if (!caseSensitive) {
        index = [self rangeOfString:substring options:NSCaseInsensitiveSearch].location;
    } else {
        index = [self rangeOfString:substring].location;
    }
    return index != NSNotFound;
}



@end
