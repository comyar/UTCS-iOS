//
//  UTCSAbstractHeaderTable.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSHeaderTableViewController.h"
#import "UTCSActiveHeaderView.h"


#pragma mark - UTCSAbstractHeaderTable

@interface UTCSHeaderTableViewController ()

@end


#pragma mark - UTCSAbstractHeaderTableViewController Implementation

@implementation UTCSHeaderTableViewController
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
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat normalizedOffsetDelta = MAX(self.tableView.contentOffset.y / CGRectGetHeight(self.tableView.bounds), 0.0);
        self.backgroundBlurredImageView.alpha = MIN(1.0, 4.0 * normalizedOffsetDelta);
    }
}

#pragma mark Setters

- (void)setActivityHeaderView:(UTCSActiveHeaderView *)activityHeaderView
{
    _activityHeaderView             = activityHeaderView;
    _activityHeaderView.frame       = self.tableView.bounds;
    self.tableView.tableHeaderView  = _activityHeaderView;
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
