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
        
        self.blurredImageView = [[UIImageView alloc]initWithImage:self.defaultBlurredHeaders[0]];
        self.blurredImageView.alpha = 0.0;
        
        
        
        self.headerContainer = [UIView new];
        self.headerContainer.backgroundColor = [UIColor clearColor];
        
        self.headerContainer.frame = CGRectMake(0, 0, self.headerImageView.width, self.headerImageView.height);
        [self.headerContainer addSubview:self.headerImageView];
        [self.headerContainer addSubview:self.blurredImageView];
        
        [self.view addSubview:self.headerContainer];
        
        
        
        self.headerTitleLabel = [[UILabel alloc]initWithFrame:self.headerContainer.bounds];
        self.headerTitleLabel.numberOfLines = 0;
        self.headerTitleLabel.adjustsFontSizeToFitWidth = YES;
        self.headerTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.headerTitleLabel.shadowOffset = CGSizeMake(0, 1);
        self.headerTitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self.headerContainer addSubview:self.headerTitleLabel];
        
        
        [self.headerContainer addSubview:self.headerTitleLabel];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
        
        self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 0.0)];
        self.contentTextView.scrollEnabled = NO;
        self.contentTextView.editable = NO;
        [self.scrollView addSubview:self.contentTextView];
        
        self.headerMask = [CAShapeLayer layer];
    }
    return self;
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
    CGFloat height = [newsStory.title boundingRectWithSize:self.headerTitleLabel.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.headerTitleLabel.font} context:nil].size.height;
    
//    self.headerTitleLabel.y = self.headerContainer.height - height;
    self.headerTitleLabel.text = newsStory.title;
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
        self.blurredImageView.alpha = MIN(1.0,  10.0 * MAX(scrollView.contentOffset.y / self.view.height, 0.0));
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
