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

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    self.tableView.tableHeaderView.frame = self.tableView.bounds;
}

#pragma mark Update

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat normalizedOffsetDelta = MAX(self.tableView.contentOffset.y / CGRectGetHeight(self.tableView.bounds), 0.0);
        CGFloat multiplier = FBTweakValue(@"Header Table View Controller", @"Background Blur Image View", @"Multipler", 2.0);
        self.backgroundBlurredImageView.alpha = MIN(1.0, multiplier * normalizedOffsetDelta);
    }
}

#pragma mark Setters

- (void)setActiveHeaderView:(UTCSActiveHeaderView *)activityHeaderView
{
    _activeHeaderView             = activityHeaderView;
    _activeHeaderView.frame       = self.tableView.bounds;
    self.tableView.tableHeaderView  = _activeHeaderView;
}

#pragma mark Getters

- (UIImageView *)backgroundBlurredImageView
{
    if (!_backgroundBlurredImageView) {
        _backgroundBlurredImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backgroundBlurredImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundBlurredImageView.clipsToBounds = YES;
        _backgroundBlurredImageView.alpha = 0.0;    // alpha is initially 0.0 and affected only by content offset
        [self.view insertSubview:_backgroundBlurredImageView aboveSubview:self.backgroundImageView];
    }

    return _backgroundBlurredImageView;
}

#pragma mark Dealloc

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
