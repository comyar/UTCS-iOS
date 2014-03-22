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

#import "UTCSParallaxHeaderScrollView.h"


@interface UTCSNewsDetailViewController ()

@property (nonatomic) UTCSParallaxHeaderScrollView      *parallaxScrollView;

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
        self.view.backgroundColor = [UIColor blackColor];
        self.defaultHeaders = @[[UIImage imageNamed:@"header"]];
        self.defaultBlurredHeaders = @[[UIImage imageNamed:@"blurredHeader"]];
        
        self.headerImageView = [[UIImageView alloc]initWithImage:self.defaultHeaders[0]];
        
        self.blurredImageView = [[UIImageView alloc]initWithImage:self.defaultBlurredHeaders[0]];
        self.blurredImageView.alpha = 0.0;
        
        self.headerContainer = [UIView new];
        self.headerContainer.backgroundColor = [UIColor clearColor];
        
        self.headerContainer.frame = CGRectMake(0, 0, self.headerImageView.width, self.headerImageView.height);
        [self.headerContainer addSubview:self.headerImageView];
        [self.headerContainer addSubview:self.blurredImageView];
        
        self.parallaxScrollView = [[UTCSParallaxHeaderScrollView alloc]initWithFrame:self.view.bounds headerView:self.headerImageView];
        self.parallaxScrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.parallaxScrollView];

    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    }

- (void)updateWithNewsStory:(UTCSNewsStory *)newsStory
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.blurredImageView.alpha = MIN(1.0,  10.0 * MAX(scrollView.contentOffset.y / self.view.height, 0.0));
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
