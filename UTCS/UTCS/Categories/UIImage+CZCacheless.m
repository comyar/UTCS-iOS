//
//  UIImage+CZCacheless.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UIImage+CZCacheless.h"

@implementation UIImage (CZCacheless)

+ (UIImage *)cacheless_imageNamed:(NSString *)name
{
    NSString *retinaName    = [NSString stringWithFormat:@"%@@2x", name];
    
    NSLog(@"retinaName : %@", retinaName);
    
    
    NSString *path          = [[NSBundle mainBundle]pathForResource:name ofType:@"png"];
    NSString *retinaPath    = [[NSBundle mainBundle]pathForResource:retinaName ofType:@"png"];
    
    NSLog(@"path : %@", path);
    NSLog(@"retinaPath : %@", path);
    
    UIImage *retinaImage = [UIImage imageWithContentsOfFile:retinaPath];
    if (retinaImage) {
        return retinaImage;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

@end
