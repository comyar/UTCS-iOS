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

@property (nonatomic) UIScrollView                      *scrollView;
@property (strong, nonatomic) UITextView                *contentTextView;

@property (nonatomic) NSArray                           *defaultHeaders;
@property (nonatomic) NSArray                           *defaultBlurredHeaders;


@property (nonatomic) UIImageView                       *headerImageView;
@property (nonatomic) UIImageView                       *blurredImageView;

@property (nonatomic) UIView                            *headerContainer;

@property (nonatomic) UILabel                           *headerTitleLabel;
@property (nonatomic) UILabel                           *headerDateLabel;

@property (nonatomic) CAShapeLayer                      *headerMask;

@end

@implementation UTCSNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.defaultHeaders = @[[UIImage imageNamed:@"header"]];
        self.defaultBlurredHeaders = @[[UIImage imageNamed:@"blurredHeader"]];
        
        self.headerImageView = [[UIImageView alloc]initWithImage:self.defaultHeaders[0]];
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.blurredImageView = [[UIImageView alloc]initWithImage:self.defaultBlurredHeaders[0]];
        self.blurredImageView.alpha = 0.0;
        
        self.headerContainer = [UIView new];
        self.headerContainer.backgroundColor = [UIColor clearColor];
        
        self.headerContainer.frame = CGRectMake(0, 0, self.headerImageView.width, self.headerImageView.height);
        [self.headerContainer addSubview:self.headerImageView];
        [self.headerContainer addSubview:self.blurredImageView];
        
        [self.view addSubview:self.headerContainer];
        
        self.headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8.0, 64.0, self.headerContainer.width - 16.0, self.headerContainer.height - 96.0)];
        self.headerTitleLabel.numberOfLines = 0;
        self.headerTitleLabel.adjustsFontSizeToFitWidth = YES;
        self.headerTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28];
        self.headerTitleLabel.textColor = [UIColor whiteColor];
        [self.headerContainer addSubview:self.headerTitleLabel];
        
        self.headerDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(8.0, 0.0, self.view.width - 16.0, 32)];
        self.headerDateLabel.adjustsFontSizeToFitWidth = YES;
        self.headerDateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        self.headerDateLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self.headerContainer addSubview:self.headerDateLabel];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
        
        self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 0.0)];
        self.contentTextView.textContainerInset = UIEdgeInsetsMake(16.0, 8.0, 8.0, 8.0);
        self.contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        self.contentTextView.scrollEnabled = NO;
        self.contentTextView.editable = NO;
        self.contentTextView.delegate = self;
        [self.scrollView addSubview:self.contentTextView];
        
        self.headerMask = [CAShapeLayer layer];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return NO;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)updateWithNewsStory:(UTCSNewsStory *)newsStory
{
    if(newsStory.headerImage) {
        self.headerImageView.image = newsStory.headerImage;
    }
    
    
    self.headerDateLabel.text = [NSDateFormatter localizedStringFromDate:newsStory.date
                                                               dateStyle:NSDateFormatterLongStyle
                                                               timeStyle:NSDateFormatterNoStyle];
    
    self.headerTitleLabel.text = newsStory.title;
    [self.headerTitleLabel sizeToFit];
    self.headerTitleLabel.y = self.headerContainer.height - self.headerTitleLabel.height - self.headerDateLabel.height;
    self.headerDateLabel.y = self.headerContainer.height - self.headerDateLabel.height;
    self.contentTextView.attributedText = newsStory.attributedContent;
    self.contentTextView.y = self.headerContainer.height;
    self.contentTextView.height = [self.contentTextView heightWithText];
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.contentTextView.height + self.headerContainer.height);
    [self.scrollView scrollRectToVisible:CGRectZero animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView) {
        if(scrollView.contentOffset.y > 0) {
            if(self.scrollView.contentOffset.y < self.headerContainer.height - 64.0) {
                self.headerContainer.y = -0.5 * scrollView.contentOffset.y;
                [self.view sendSubviewToBack:self.headerContainer];
                self.headerContainer.layer.masksToBounds = NO;
                self.headerContainer.layer.mask = nil;
            } else {
                self.headerMask.path = [[UIBezierPath bezierPathWithRect:CGRectMake(self.headerContainer.x, -self.headerContainer.y, self.headerContainer.width, 64.0)]CGPath];
                [self.view bringSubviewToFront:self.headerContainer];
                self.headerContainer.layer.mask = self.headerMask;
            }
        } else {
            self.headerContainer.y = 0.0;
        }
        self.blurredImageView.alpha = MIN(1.0, 10.0 * MAX(scrollView.contentOffset.y / self.view.height, 0.0));
        self.headerTitleLabel.alpha = 1.0 - MIN(1.0, 4.0 * MAX(scrollView.contentOffset.y / self.view.height, 0.0));
    }
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
