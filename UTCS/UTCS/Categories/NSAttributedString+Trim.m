//
//  NSAttributedString+Trim.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/11/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "NSAttributedString+Trim.h"

@implementation NSAttributedString (Trim)

- (NSAttributedString *)attributedStringByTrimming:(NSCharacterSet *)set
{
    NSCharacterSet *invertedSet = set.invertedSet;
    NSString *string = self.string;
    unsigned int loc, len;
    
    NSRange range = [string rangeOfCharacterFromSet:invertedSet];
    loc = (range.length > 0) ? (int)range.location : 0;
    
    range = [string rangeOfCharacterFromSet:invertedSet options:NSBackwardsSearch];
    len = (range.length > 0) ? (int)NSMaxRange(range) - loc : (int)string.length - loc;
    
    return [self attributedSubstringFromRange:NSMakeRange(loc, len)];
}

@end
