//
//  UTCSNewsDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsDetailViewController.h"
#import "UIView+CZPositioning.h"
#import "UIColor+UTCSColors.h"
#import "UITextView+CZTextViewHeight.h"
#import "UTCSNewsStory.h"


@interface UTCSNewsDetailViewController ()

@property (strong, nonatomic) UITextView                *contentTextView;

@property (nonatomic) NSArray                           *defaultHeaders;
@property (nonatomic) NSArray                           *defaultBlurredHeaders;


@property (nonatomic) UIImageView                       *headerImageView;
@property (nonatomic) UIImageView                       *blurredImageView;

@property (nonatomic) UIView                            *headerContainer;

@end

@implementation UTCSNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.defaultHeaders = @[[UIImage imageNamed:@"header"]];
        self.defaultBlurredHeaders = @[[UIImage imageNamed:@"blurredHeader"]];
        
        self.headerImageView = [[UIImageView alloc]initWithImage:self.defaultHeaders[0]];
        self.headerImageView.frame = CGRectMake(0, 0, self.view.width, 0.5 * self.view.height);
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.blurredImageView = [[UIImageView alloc]initWithImage:self.defaultBlurredHeaders[0]];
        self.blurredImageView.frame = CGRectMake(0, 0, self.view.width, 0.5 * self.view.height);
        self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.blurredImageView.alpha = 0.0;
        
        self.headerContainer = [UIView new];
        
        
        self.contentTextView = [[UITextView alloc]initWithFrame:CGRectZero];
        self.contentTextView.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor utcsBurntOrangeColor]};
        self.contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        self.contentTextView.scrollEnabled = YES;
        self.contentTextView.editable = NO;
        self.contentTextView.delegate = self;
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.headerContainer addSubview:self.headerImageView];
    [self.headerContainer addSubview:self.blurredImageView];
    [self.headerContainer sizeToFit];
    [self.view addSubview:self.headerContainer];
    
    
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.contentTextView.frame = self.view.bounds;
    [self.view addSubview:self.contentTextView];
}

- (void)updateWithNewsStory:(UTCSNewsStory *)newsStory
{
    [self.contentTextView scrollRangeToVisible:NSMakeRange(0, 1)];
    
    self.contentTextView.contentInset = UIEdgeInsetsMake(self.headerImageView.height, 0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.blurredImageView.alpha = MIN(1.0,  MAX(scrollView.contentOffset.y / self.view.height, 0.0));
}

#pragma mark Overridden Setters

- (void)setNewsStory:(UTCSNewsStory *)newsStory
{
    if(newsStory == _newsStory) {
        return;
    }
    
    _newsStory = newsStory;
    [self updateWithNewsStory:newsStory];
}

@end
