//
//  UITextView+CZTextViewHeight.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/26/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UITextView+CZTextViewHeight.h"

@implementation UITextView (CZTextViewHeight)

- (CGFloat)heightWithText
{
    return [self.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds), NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
}

@end
