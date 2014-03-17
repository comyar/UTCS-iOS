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

@property (strong, nonatomic) UIScrollView              *scrollView;

@property (strong, nonatomic) UITextView                *contentTextView;

@end

@implementation UTCSNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.contentTextView = [[UITextView alloc]initWithFrame:CGRectZero];
        self.contentTextView.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor utcsBurntOrangeColor]};
        self.contentTextView.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber;
        self.contentTextView.scrollEnabled = YES;
        self.contentTextView.editable = NO;
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentTextView.frame = CGRectMake(8.0, 8.0, self.view.width - 16.0, self.view.height - 8.0);
    [self.view addSubview:self.contentTextView];
}

- (void)updateWithNewsStory:(UTCSNewsStory *)newsStory
{
    self.title = [NSDateFormatter localizedStringFromDate:newsStory.date
                                                dateStyle:NSDateFormatterMediumStyle
                                                timeStyle:NSDateFormatterNoStyle];
    
    self.contentTextView.attributedText = newsStory.attributedContent;
    [self.contentTextView scrollRangeToVisible:NSMakeRange(0, 1)];
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
