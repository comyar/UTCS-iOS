//
//  UIImage+CZScaling.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UIImage+CZScaling.h"

@implementation UIImage (CZScaling)

- (UIImage *)imageScaledToFitWidth:(CGFloat)width
{
    if(self.size.width < width) {
        return [self copy];
    }
    
    CGFloat widthScale = width / self.size.width;
    CGSize scaleSize = CGSizeMake(widthScale * self.size.width, widthScale * self.size.height);
    
    UIGraphicsBeginImageContext(scaleSize);
    [self drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;

}

@end
