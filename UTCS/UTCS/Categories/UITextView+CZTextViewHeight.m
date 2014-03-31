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

- (CGSize)sizeForWidth:(CGFloat)width height:(CGFloat)height
{
    CGSize size = CGSizeZero;
    if(![self.attributedText length]) {
        return size;
    }
    
    CGSize givenSize = CGSizeMake(width, height);
    NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:givenSize];
    NSTextStorage *textStorage = [[NSTextStorage alloc]initWithAttributedString:self.attributedText];
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [layoutManager setHyphenationFactor:0.0];
    
    // NSLayoutManager is lazy, so we need the following kludge to force layout:
    [layoutManager glyphRangeForTextContainer:textContainer];
    
    size = [layoutManager usedRectForTextContainer:textContainer].size;
    
    // Adjust if there is extra height for the cursor
    CGSize extraLineSize = [layoutManager extraLineFragmentRect].size ;
    if (extraLineSize.height > 0) {
        size.height -= extraLineSize.height ;
    }
    
	return size;
}

@end
