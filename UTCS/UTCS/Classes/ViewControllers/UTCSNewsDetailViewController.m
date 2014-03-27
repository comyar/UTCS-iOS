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
#import "UTCSParallaxBlurHeaderScrollView.h"


@interface UTCSNewsDetailViewController ()

@property (nonatomic) UITextView                        *contentTextView;
@property (nonatomic) UTCSParallaxBlurHeaderScrollView  *parallaxBlurHeaderScrollView;

@end

@implementation UTCSNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.parallaxBlurHeaderScrollView = [[UTCSParallaxBlurHeaderScrollView alloc]initWithFrame:self.view.bounds];
        self.parallaxBlurHeaderScrollView.headerImage = [UIImage imageNamed:@"header"];
        self.parallaxBlurHeaderScrollView.headerBlurredImage = [UIImage imageNamed:@"blurredHeader"];
        
        self.contentTextView = [[UITextView alloc]initWithFrame:self.parallaxBlurHeaderScrollView.scrollView.bounds];
        self.contentTextView.scrollEnabled = NO;
        self.contentTextView.editable = NO;
        [self.parallaxBlurHeaderScrollView.scrollView addSubview:self.contentTextView];
        
        [self.view addSubview:self.parallaxBlurHeaderScrollView];
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)updateWithNewsStory:(UTCSNewsStory *)newsStory
{
    self.title = [NSDateFormatter localizedStringFromDate:newsStory.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    self.contentTextView.attributedText = newsStory.attributedContent;
    self.contentTextView.height = [self.contentTextView heightWithText];
    self.contentTextView.y = self.parallaxBlurHeaderScrollView.headerImage.size.height;
    self.parallaxBlurHeaderScrollView.scrollView.contentSize = CGSizeMake(self.parallaxBlurHeaderScrollView.width, self.contentTextView.height + self.parallaxBlurHeaderScrollView.headerContainerView.height);
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
