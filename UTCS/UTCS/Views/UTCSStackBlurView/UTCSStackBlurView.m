//
//  UTCSStackBlurView.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/11/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSStackBlurView.h"
#import "UIImage+ImageEffects.h"

@interface UTCSStackBlurView ()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) NSArray *images;

@property (assign, nonatomic) CGFloat delta;

@property (assign, nonatomic) NSInteger index;

@property (assign, nonatomic, getter = isRendered) BOOL rendered;

@end


#pragma mark - UTCSStackBlurView Implementation

@implementation UTCSStackBlurView

#pragma mark Creating a UTCSStackBlurView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame image:nil count:20];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    return [self initWithFrame:frame image:image count:20];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image count:(NSInteger)count
{
    if(self = [super initWithFrame:frame]) {
        _image = image;
        _count = count;
        _maxBlurRadius = 10.0;
        _imageView = [[UIImageView alloc]initWithFrame:frame];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return self;
}

#pragma mark Using a UTCSStackBlurView

- (void)renderBlurWithCompletion:(void (^)(void))completion
{
    if (!_image)
        return;
    
    NSMutableArray *images = [NSMutableArray new];
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    
    CGFloat blurDelta = _maxBlurRadius / _count;
    for (int i = 1; i < _count + 1; ++i) {
        images[i - 1] = [_image applyBlurWithRadius:(i * blurDelta) tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    }
    self.images = images;
    if(completion) {
        completion();
    }
    [self updateWithDelta:self.delta];
}

- (void)updateWithDelta:(CGFloat)delta
{
    _delta = MAX(0.0, MIN(1.0, delta));
    _index = (NSInteger)floorf((self.count - 1) * self.delta);
    self.imageView.image = self.images[_index];
}

- (void)blurWithDuration:(NSTimeInterval)duration
{
    CGFloat durationInterval = 0.0;
    if (_index) {
        durationInterval = duration / (self.count - 1 - _index);
    }
    for (NSInteger i = _index; i < _count; ++i) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i - _index) * durationInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.imageView.image = self.images[i];
        });
    }
    _index = self.count - 1;
    _delta = 1.0;
}

- (void)unblurWithDuration:(NSTimeInterval)duration
{
    CGFloat durationInterval = 0.0;
    if (_index) {
        durationInterval = duration / _index;
    }
    for (NSInteger i = _index; i >= 0; --i) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_index - i) * durationInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.imageView.image = self.images[i];
        });
    }
    
    _index = 0;
    _delta = 0.0;
}

@end
