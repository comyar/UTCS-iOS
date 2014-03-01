//
//  UIView+FrameBounds.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UIView+FrameBounds.h"

@implementation UIView (FrameBounds)

- (CGFloat)frameX
{
    return self.frame.origin.x;
}

- (CGFloat)frameY
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.bounds);
}

@end
