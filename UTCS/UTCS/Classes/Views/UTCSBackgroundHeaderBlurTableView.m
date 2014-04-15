//
//  UTCSHeaderBlurTableView.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSBackgroundHeaderBlurTableView.h"


#pragma mark - UTCSBackgroundHeaderBlurTableView Class Extension

@interface UTCSBackgroundHeaderBlurTableView ()

//
@property (nonatomic) UIView        *header;

//
@property (nonatomic) UITableView   *tableView;

//
@property (nonatomic) UIImageView   *backgroundImageView;

//
@property (nonatomic) UIImageView   *backgroundBlurredImageView;

//
@property (nonatomic) CAShapeLayer  *navigationSeparatorLayer;

//
@property (nonatomic) UIButton      *scrollToTopButton;

@end


#pragma mark - UTCSBackgroundHeaderBlurTableView Implementation

@implementation UTCSBackgroundHeaderBlurTableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // Background image view
        self.backgroundImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
        
        // Background blurred image view
        self.backgroundBlurredImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.alpha = 0.0;
            imageView;
        });
        
        // Header
        self.header = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 44.0)];
        
        // Table view
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 44.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 44.0) style:UITableViewStylePlain];
            [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.1];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.showsVerticalScrollIndicator = NO;
            tableView.tableHeaderView = self.header;
            tableView;
        });
        
        // Navigation separator layer
        self.navigationSeparatorLayer = ({
            CAShapeLayer *layer = [CAShapeLayer new];
            layer.strokeColor = [UIColor clearColor].CGColor;
            layer.lineWidth = 0.5;
            layer.path = ({
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0.0, 43.5)];
                [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), 43.5)];
                path.CGPath;
            });
            layer;
        });
        
        // Scroll to top button
        self.scrollToTopButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
            button.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), 44.0);
            button;
        });
        
        // Add subviews
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.backgroundBlurredImageView];
        [self addSubview:self.tableView];
        [self.layer addSublayer:self.navigationSeparatorLayer];
        [self addSubview:self.scrollToTopButton];
    }
    return self;
}

- (void)didTouchDownInsideButton:(UIButton *)button
{
    if(button == self.scrollToTopButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, .0, 1.0, 1.0) animated:YES];
    }
}

#pragma mark Update

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"]) {
        [self updateWithContentOffset:self.tableView.contentOffset];
    }
}

- (void)updateWithContentOffset:(CGPoint)contentOffset
{
    CGFloat normalizedOffsetDelta = MAX(contentOffset.y / CGRectGetHeight(self.bounds), 0.0);
    self.backgroundBlurredImageView.alpha = MIN(1.0, 4.0 * normalizedOffsetDelta);
    self.navigationSeparatorLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:normalizedOffsetDelta].CGColor;
}

#pragma mark Setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    _backgroundImageView.image = _backgroundImage;
    _tableView.backgroundColor = (backgroundImage)? [UIColor clearColor] : [UIColor blackColor];
}

- (void)setBackgroundBlurredImage:(UIImage *)backgroundBlurredImage
{
    _backgroundBlurredImage = backgroundBlurredImage;
    _backgroundBlurredImageView.image = _backgroundBlurredImage;
    _tableView.backgroundColor = (backgroundBlurredImage)? [UIColor clearColor] : [UIColor blackColor];
}

@end
