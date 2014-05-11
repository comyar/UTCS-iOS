//
//  UIImage+CZScaling.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CZScaling)

- (UIImage *)imageScaledToFitWidth:(CGFloat)width;
- (UIImage*)imageScaledByFactor:(CGFloat)scale;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize;

@end
