//
//  UTCSNewsDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsDetailViewController.h"
#import "UIView+Positioning.h"
#import "UIColor+UTCSColors.h"
#import "UITextView+CZTextViewHeight.h"
#import "UTCSNewsStory.h"

@interface UTCSNewsDetailViewController ()

@property (strong, nonatomic) NSDateFormatter   *dateFormatter;

@property (strong, nonatomic) NSMutableArray    *imageViewPool;

@property (strong, nonatomic) UIScrollView      *scrollView;

@property (strong, nonatomic) UITextView        *contentTextView;

@property (strong, nonatomic) NSMutableAttributedString *attributedText;

@end

@implementation UTCSNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"News";
        self.dateFormatter = ({
            NSDateFormatter *dateFormatter  = [NSDateFormatter new];
            dateFormatter.timeZone          = [NSTimeZone timeZoneWithName:@"GMT"];
            dateFormatter.dateFormat        = @"MMMM d, yyyy";
            dateFormatter;
        });
        [self initializeSubviews];
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView scrollRectToVisible:CGRectMake(0.0, 0.0, self.view.width, 1.0) animated:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)initializeSubviews
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(8.0, 0, self.view.width - 16.0, self.view.height)];
    [self.scrollView addSubview:self.contentTextView];
}

- (void)updateWithNewsStory:(UTCSNewsStory *)newsStory
{
    self.attributedText = [NSMutableAttributedString new];
    
    NSString *titleText = [NSString stringWithFormat:@"%@\n", newsStory.title];
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc]initWithString:titleText attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline], NSForegroundColorAttributeName: [UIColor blackColor]}];
    [self.attributedText appendAttributedString:titleAttributedString];
    
    NSString *dateText = [NSString stringWithFormat:@"%@\n\n", [self.dateFormatter stringFromDate:newsStory.date]];
    NSMutableAttributedString *dateAttributedString = [[NSMutableAttributedString alloc]initWithString:dateText attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName: [UIColor utcsLightGrayColor]}];
    [self.attributedText appendAttributedString:dateAttributedString];
    
    
    for(NSDictionary *content in newsStory.jsonContent) {
        if([content[@"type"]isEqualToString:@"text"]) {
            NSString *contentText = content[@"content"];
            NSLog(@"%@", contentText);
//            NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc]initWithString:contentText attributes:@{NSFontAttributeName: UIFontTextStyleBody, NSForegroundColorAttributeName: [UIColor utcsDarkGrayColor]}];
//            [self.attributedText appendAttributedString:contentAttributedString];
        }
    }
    
    self.contentTextView.attributedText = self.attributedText;
}

#pragma mark Overridden Setters

- (void)setNewsStory:(UTCSNewsStory *)newsStory
{
    _newsStory = newsStory;
    [self updateWithNewsStory:_newsStory];
}

@end
