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
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.bounds) - self.textContainerInset.left - self.textContainerInset.right, CGFLOAT_MAX);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [self.attributedText length]), NULL, targetSize, NULL);
    CFRelease(framesetter);
    return size.height;
}

@end
