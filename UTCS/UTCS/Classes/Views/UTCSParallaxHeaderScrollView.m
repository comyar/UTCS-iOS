//
//  UTCSParallaxHeaderScrollView.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSParallaxHeaderScrollView.h"

@interface UTCSParallaxHeaderHandler : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView headerView:(UIView *)headerView;

@property (nonatomic) UIView        *headerView;
@property (nonatomic) UIScrollView  *scrollView;


@end

@implementation UTCSParallaxHeaderHandler

- (instancetype)initWithScrollView:(UIScrollView *)scrollView headerView:(UIView *)headerView
{
    if(self = [super init]) {
        _scrollView = scrollView;
        _headerView = headerView;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"]) {
        NSLog(@"asdfasdfa");
        CGRect headerViewFrame = self.headerView.frame;
        if(self.scrollView.contentOffset.y < 0) {
            headerViewFrame.origin.y = self.scrollView.contentOffset.y;
            
        } else {
            headerViewFrame.origin.y = self.scrollView.frame.origin.y;
        }
        self.headerView.frame = headerViewFrame;
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x,
                                self.headerView.frame.origin.y + CGRectGetHeight(self.headerView.frame),
                                self.scrollView.frame.size.width,
                                self.scrollView.frame.size.height);
    }
}

@end


@interface UTCSParallaxHeaderScrollView ()
@property (nonatomic) UTCSParallaxHeaderHandler *handler;
@end

@implementation UTCSParallaxHeaderScrollView

- (instancetype)initWithFrame:(CGRect)frame headerView:(UIView *)headerView
{
    if (self = [super initWithFrame:frame]) {
        _handler = [[UTCSParallaxHeaderHandler alloc]initWithScrollView:self headerView:headerView];
        [_handler addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setHeaderView:(UIView *)headerView
{
    if(_headerView == headerView) {
        return;
    }
    [_headerView removeFromSuperview];
    
    _headerView = headerView;
    [self addSubview:_headerView];
    _handler.headerView = _headerView;
    [self setContentOffset:CGPointZero animated:YES];
}

@end
