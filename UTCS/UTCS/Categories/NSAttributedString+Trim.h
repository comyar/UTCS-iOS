//
//  NSAttributedString+Trim.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/11/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

@interface NSAttributedString (Trim)

- (NSAttributedString *)attributedStringByTrimming:(NSCharacterSet *)set;

@end
