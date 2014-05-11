//
//  UIImage+Cacheless.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/10/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UIImage+Cacheless.h"

@implementation UIImage (Cacheless)

+ (UIImage *)cacheless_imageNamed:(NSString *)imageName
{
    NSString *retinaName = [NSString stringWithFormat:@"%@@2x", imageName];
    NSString *retinaPath = [[NSBundle mainBundle]pathForResource:retinaName ofType:@"png"];
    UIImage *retinaImage = [UIImage imageWithContentsOfFile:retinaPath];
    
    if (retinaImage) {
        return retinaImage;
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

@end
