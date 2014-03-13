//
//  UTCSStackBlurView.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/11/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTCSStackBlurView : UIView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image count:(NSInteger)count;

- (void)updateWithDelta:(CGFloat)delta;

- (void)blurWithDuration:(NSTimeInterval)duration;
- (void)unblurWithDuration:(NSTimeInterval)duration;

- (void)renderBlurWithCompletion:(void(^)(void))completion;

@property (strong, nonatomic) UIImage   *image;

@property (assign, nonatomic) NSInteger count;

@property (assign, nonatomic) CGFloat   maxBlurRadius;

@end
