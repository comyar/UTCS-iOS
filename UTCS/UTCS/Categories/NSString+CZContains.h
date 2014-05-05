//
//  NSString+CZContains.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

@interface NSString (CZContains)

- (BOOL)contains:(NSString *)substring;
- (BOOL)contains:(NSString *)substring caseSensitive:(BOOL)caseSensitive;

@end
