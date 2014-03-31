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
        self.contentTextView.textContainerInset = UIEdgeInsetsMake(16.0, 8.0, 0, 8.0);
        self.contentTextView.scrollEnabled = NO;
        self.contentTextView.editable = NO;
        self.contentTextView.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber | UIDataDetectorTypeAddress;
        self.contentTextView.textColor = [UIColor utcsGrayColor];
        [self.parallaxBlurHeaderScrollView.scrollView addSubview:self.contentTextView];
        
        [self.view addSubview:self.parallaxBlurHeaderScrollView];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)updateWithNewsStory:(UTCSNewsStory *)newsStory
{
    self.title = [NSDateFormatter localizedStringFromDate:newsStory.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    
    if(newsStory.headerImage) {
        self.parallaxBlurHeaderScrollView.headerImage = newsStory.headerImage;
        self.parallaxBlurHeaderScrollView.headerBlurredImage = newsStory.blurredHeaderImage;
    }
    
    self.contentTextView.attributedText = newsStory.attributedContent;
    self.contentTextView.height = [self.contentTextView sizeForWidth:self.contentTextView.textContainer.size.width height:CGFLOAT_MAX].height;
    self.contentTextView.y = self.parallaxBlurHeaderScrollView.headerImage.size.height;
    self.parallaxBlurHeaderScrollView.scrollView.contentSize = CGSizeMake(self.parallaxBlurHeaderScrollView.width, self.contentTextView.height + self.parallaxBlurHeaderScrollView.headerImage.size.height);
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
