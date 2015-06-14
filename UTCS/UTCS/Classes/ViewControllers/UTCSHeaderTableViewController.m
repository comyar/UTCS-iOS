//
//  UTCSAbstractHeaderTable.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSHeaderTableViewController.h"


#pragma mark - Constants

// Modifier for the rate at which the background image view's alpha changes
static const CGFloat blurAlphaModifier              = 2.0;

// Content offset property string used for KVO
static NSString * const contentOffsetPropertyString = @"contentOffset";


#pragma mark - UTCSHeaderTableViewController Class Extension

@interface UTCSHeaderTableViewController ()

// Image view intended to display a blurred version of the  view controller's background image
@property (nonatomic) UIImageView     *backgroundBlurredImageView;

@end


#pragma mark - UTCSHeaderTableViewController Implementation

@implementation UTCSHeaderTableViewController

#pragma mark Creating a UTCSHeaderTableViewController

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
        
        [self.tableView addObserver:self forKeyPath:contentOffsetPropertyString options:NSKeyValueObservingOptionNew context:nil];
        
        self.backgroundBlurredImageView = ({
            UIImageView *imageView  = [UIImageView new];
            imageView.contentMode   = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.alpha         = 0.0;
            imageView;
        });
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    self.tableView.tableHeaderView.frame = self.tableView.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view insertSubview:self.backgroundBlurredImageView aboveSubview:self.backgroundImageView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.backgroundBlurredImageView.frame = self.view.bounds;
}

#pragma mark Key-Value Observing Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if([keyPath isEqualToString:contentOffsetPropertyString]) {
        CGFloat normalizedOffsetDelta = MAX(self.tableView.contentOffset.y / CGRectGetHeight(self.tableView.bounds), 0.0);
        self.backgroundBlurredImageView.alpha = MIN(1.0, blurAlphaModifier * normalizedOffsetDelta);
    }
}

#pragma mark Setters

- (void)setActiveHeaderView:(ActiveHeaderView *)activityHeaderView
{
    _activeHeaderView               = activityHeaderView;
    _activeHeaderView.frame         = self.tableView.bounds;
    self.tableView.tableHeaderView  = _activeHeaderView;
}

#pragma mark Dealloc

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:contentOffsetPropertyString];
}

@end
