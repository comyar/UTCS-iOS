//
//  UTCSHeaderBlurTableView.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSBackgroundHeaderBlurTableView.h"

static const CGFloat navigationBarHeight = 64.0;


@interface UTCSBackgroundHeaderBlurTableView ()

@property (nonatomic) UIImageView   *backgroundImageView;

@property (nonatomic) UIImageView   *backgroundBlurredImageView;

@property (nonatomic) UIView        *header;

@property (nonatomic) UITableView   *tableView;

@property (nonatomic) UIView        *navigationSeparatorView;

@end

@implementation UTCSBackgroundHeaderBlurTableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.layer.masksToBounds = YES;
        [self addSubview:self.backgroundImageView];
        
        self.backgroundBlurredImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.backgroundBlurredImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundBlurredImageView.layer.masksToBounds = YES;
        self.backgroundBlurredImageView.alpha = 0.0;
        [self addSubview:self.backgroundBlurredImageView];
        
        self.header = [[UIView alloc]initWithFrame:self.bounds];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - navigationBarHeight) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        self.tableView.tableHeaderView = self.header;
        [self addSubview:self.tableView];
        
        self.navigationSeparatorView = [[UIView alloc]initWithFrame:CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(self.bounds), 0.5)];
        self.navigationSeparatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.navigationSeparatorView.alpha = 0.0;
        [self addSubview:self.navigationSeparatorView];
    }
    return self;
}

#pragma mark Update

- (void)tableViewDidScroll
{
    CGFloat normalizedOffsetDelta = MAX(self.tableView.contentOffset.y / CGRectGetHeight(self.bounds), 0.0);
    self.backgroundBlurredImageView.alpha = MIN(1.0, 4.0 * normalizedOffsetDelta);
    self.navigationSeparatorView.alpha = MIN(1.0, 2.0 * normalizedOffsetDelta);
}

#pragma mark Setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = _backgroundImage;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)setBackgroundBlurredImage:(UIImage *)backgroundBlurredImage
{
    _backgroundBlurredImage = backgroundBlurredImage;
    self.backgroundBlurredImageView.image = _backgroundBlurredImage;
    self.tableView.backgroundColor = [UIColor clearColor];
}



@end
