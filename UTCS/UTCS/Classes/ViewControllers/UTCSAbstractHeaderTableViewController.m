//
//  UTCSAbstractHeaderTable.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAbstractHeaderTableViewController.h"
#import "UTCSActivityHeaderView.h"


#pragma mark - UTCSAbstractHeaderTable

@interface UTCSAbstractHeaderTableViewController ()

@end


#pragma mark - UTCSAbstractHeaderTableViewController Implementation

@implementation UTCSAbstractHeaderTableViewController
@synthesize backgroundBlurredImageView = _backgroundBlurredImageView;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
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
    CGFloat normalizedOffsetDelta = MAX(self.tableView.contentOffset.y / CGRectGetHeight(self.tableView.bounds), 0.0);
    self.backgroundBlurredImageView.alpha = MIN(1.0, 4.0 * normalizedOffsetDelta);
}

#pragma mark Setters

- (void)setActivityHeaderView:(UTCSActivityHeaderView *)activityHeaderView
{
    _activityHeaderView             = activityHeaderView;
    self.tableView.tableHeaderView  = activityHeaderView;
}

#pragma mark Getters

- (UIImageView *)backgroundBlurredImageView
{
    if (!_backgroundBlurredImageView) {
        _backgroundBlurredImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backgroundBlurredImageView.alpha = 0.0;    // alpha is initially 0.0 and affected only by content offset
        [self.view insertSubview:_backgroundBlurredImageView aboveSubview:self.backgroundImageView];
    }

    return _backgroundBlurredImageView;
}

@end
