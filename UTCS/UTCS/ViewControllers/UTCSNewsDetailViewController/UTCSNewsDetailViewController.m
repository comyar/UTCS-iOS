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

@property (strong, nonatomic) UIScrollView      *scrollView;

@property (strong, nonatomic) UITextView        *titleTextView;

@property (strong, nonatomic) UILabel           *dateLabel;

@property (strong, nonatomic) UITextView        *bodyTextView;

@property (strong, nonatomic) NSDateFormatter   *dateFormatter;

@end

@implementation UTCSNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Event";
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
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.view.width, 1) animated:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateSubviewLayouts];
}

- (void)initializeSubviews
{
    // Scroll view
    self.scrollView = ({
        UIScrollView *scrollView        = [[UIScrollView alloc]initWithFrame:CGRectZero];
        scrollView.alwaysBounceVertical = YES;
        scrollView;
    });
    [self.view addSubview:self.scrollView];
    
    // Title text view
    self.titleTextView = ({
        UITextView *textView        = [[UITextView alloc]initWithFrame:CGRectZero];
        textView.textColor          = [UIColor utcsDarkGrayColor];
        textView.editable           = NO;
        textView.scrollEnabled      = NO;
        textView.font               = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
        textView.textAlignment      = NSTextAlignmentLeft;
        textView.backgroundColor    = [UIColor clearColor];
        textView;
    });
    [self.scrollView addSubview:self.titleTextView];
    
    // Date label
    self.dateLabel = ({
        UILabel *label          = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font              = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        label.textColor         = [UIColor utcsLightGrayColor];
        label.backgroundColor   = [UIColor clearColor];
        label;
    });
    [self.scrollView addSubview:self.dateLabel];
    
    // Body text view
    self.bodyTextView = ({
        UITextView *textView        = [[UITextView alloc]initWithFrame:CGRectZero];
        textView.textColor          = [UIColor utcsDarkGrayColor];
        textView.editable           = NO;
        textView.scrollEnabled      = NO;
        textView.font               = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
        textView.textAlignment      = NSTextAlignmentLeft;
        textView.backgroundColor    = [UIColor clearColor];
        textView;
    });
    [self.scrollView addSubview:self.bodyTextView];
}

- (void)updateWithNewsStory:(UTCSNewsStory *)newsStory
{
    self.titleTextView.text             = newsStory.title;
    self.dateLabel.text                 = [self.dateFormatter stringFromDate:newsStory.date];
    self.bodyTextView.attributedText    = newsStory.attributedText;
    [self updateSubviewLayouts];
}

- (void)updateSubviewLayouts
{
    self.scrollView.frame           = self.view.bounds;
    self.titleTextView.frame        = CGRectMake(16.0, 0.0, self.view.width - 32.0, [self.titleTextView heightForText]);
    self.dateLabel.frame            = CGRectMake(21.5, self.titleTextView.y + self.titleTextView.height + 4.0,
                                                 self.view.width - 43.0, self.dateLabel.font.pointSize);
    self.bodyTextView.frame  = CGRectMake(16.0, self.dateLabel.y + self.dateLabel.height + 28.0,
                                                 self.view.width - 32.0, [self.bodyTextView heightForText]);
    self.scrollView.contentSize     = CGSizeMake(self.view.width, self.bodyTextView.y + self.bodyTextView.height + 4.0);
}

#pragma mark Overridden Setters

- (void)setNewsStory:(UTCSNewsStory *)newsStory
{
    _newsStory = newsStory;
    [self updateWithNewsStory:_newsStory];
}

@end
