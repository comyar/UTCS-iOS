//
//  UTCSNewsDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// View Controllers
#import "UTCSNewsDetailViewController.h"

// Views
#import "UTCSParallaxBlurHeaderScrollView.h"

// Models
#import "UTCSNewsStory.h"

// Categories
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"
#import "UITextView+CZTextViewHeight.h"


#pragma mark - Constants


// Font size of the title label
static const CGFloat titleLabelFontSize = 28.0;

// Font size of the date label
static const CGFloat dateLabelFontSize  = 16.0;


#pragma mark - UTCSNewsDetailViewController Class Extension

@interface UTCSNewsDetailViewController ()

// Label used to display the title of a news story
@property (nonatomic) UILabel                           *titleLabel;

// Label used to display the date of a news story
@property (nonatomic) UILabel                           *dateLabel;

// Text view used to display the news story
@property (nonatomic) UITextView                        *contentTextView;

// Scroll view used to display the content of the news story
@property (nonatomic) UTCSParallaxBlurHeaderScrollView  *parallaxBlurHeaderScrollView;

// Array of default header images
@property (nonatomic) NSArray                           *defaultHeaderImages;

// Button to scroll to the top of the scroll view
@property (nonatomic) UIButton                          *scrollToTopButton;

@end


#pragma mark - UTCSNewsDetailViewController Implementation

@implementation UTCSNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.defaultHeaderImages = @[@[[UIImage imageNamed:@"header"],
                                       [UIImage imageNamed:@"blurredHeader"]]];
        
        self.scrollToTopButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0.0, 0.0, self.view.width, 44);
            self.navigationItem.titleView = button;
            button;
        });
        
        // Parallax blur header scroll view
        self.parallaxBlurHeaderScrollView = [[UTCSParallaxBlurHeaderScrollView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.parallaxBlurHeaderScrollView];
        
        // Title label
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, self.parallaxBlurHeaderScrollView.navigationBarHeight,
                                                                      self.view.width - 16.0, 0.0)];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:titleLabelFontSize];
            label.textColor = [UIColor whiteColor];
            label.adjustsFontSizeToFitWidth = YES;
            label.numberOfLines = 0;
            label;
        });
        [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:self.titleLabel];
        
        // Date label
        self.dateLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, 0.0, self.view.width - 16.0, 1.5 * dateLabelFontSize)];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:dateLabelFontSize];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.75];
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
        [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:self.dateLabel];
        
        // Content text view
        self.contentTextView = ({
            UITextView *textView = [[UITextView alloc]initWithFrame:self.parallaxBlurHeaderScrollView.scrollView.bounds];
            textView.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber | UIDataDetectorTypeAddress;
            textView.textContainerInset = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
            textView.textColor = [UIColor utcsGrayColor];
            textView.scrollEnabled = NO;
            textView.editable = NO;
            textView;
        });
        [self.parallaxBlurHeaderScrollView.scrollView addSubview:self.contentTextView];
    }
    return self;
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.scrollToTopButton) {
        [self.parallaxBlurHeaderScrollView.scrollView scrollRectToVisible:CGRectMake(0.0, 0.0, 1, 1) animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark Setters

- (void)setNewsStory:(UTCSNewsStory *)newsStory
{
    if(newsStory == _newsStory) {
        return;
    }
    
    _newsStory = newsStory;
    
    self.parallaxBlurHeaderScrollView.scrollView.contentOffset = CGPointZero;
    
    
    self.title = [NSDateFormatter localizedStringFromDate:_newsStory.date
                                                dateStyle:NSDateFormatterLongStyle
                                                timeStyle:NSDateFormatterNoStyle];
    
    // Set header image
    if(_newsStory.headerImage) {
        self.parallaxBlurHeaderScrollView.headerImage           = _newsStory.headerImage;
        self.parallaxBlurHeaderScrollView.headerBlurredImage    = _newsStory.blurredHeaderImage;
    } else {
        // Choose a random default header
        NSInteger index = arc4random() % [self.defaultHeaderImages count];
        NSArray *headerImage = self.defaultHeaderImages[index];
        self.parallaxBlurHeaderScrollView.headerImage           = headerImage[0];
        self.parallaxBlurHeaderScrollView.headerBlurredImage    = headerImage[1];
    }
    
    self.contentTextView.attributedText = newsStory.attributedContent;
    self.contentTextView.height = [self.contentTextView sizeForWidth:self.contentTextView.textContainer.size.width
                                                              height:CGFLOAT_MAX].height + self.contentTextView.textContainerInset.top + self.contentTextView.textContainerInset.bottom;
    
    self.contentTextView.y = self.parallaxBlurHeaderScrollView.headerContainerView.height;
    
    self.parallaxBlurHeaderScrollView.scrollView.contentSize = CGSizeMake(self.parallaxBlurHeaderScrollView.width, self.contentTextView.height + self.parallaxBlurHeaderScrollView.headerContainerView.height);
    
    
    // Set date label
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:_newsStory.date
                                                         dateStyle:NSDateFormatterLongStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    self.dateLabel.y = self.parallaxBlurHeaderScrollView.headerContainerView.height - self.dateLabel.height - 8.0;
    
    // Set title label
    self.titleLabel.frame = CGRectMake(8.0, self.parallaxBlurHeaderScrollView.navigationBarHeight, self.view.width - 16.0, 0.0);
    self.titleLabel.text = _newsStory.title;
    [self.titleLabel sizeToFit];
    
    if(self.titleLabel.height > self.parallaxBlurHeaderScrollView.headerContainerView.height - self.parallaxBlurHeaderScrollView.navigationBarHeight - self.dateLabel.height) {
        self.titleLabel.height = self.parallaxBlurHeaderScrollView.headerContainerView.height - self.parallaxBlurHeaderScrollView.navigationBarHeight - self.dateLabel.height;
    }
    
    self.titleLabel.y = self.parallaxBlurHeaderScrollView.headerContainerView.height - (self.parallaxBlurHeaderScrollView.headerContainerView.height - self.dateLabel.y) - self.titleLabel.height;
}

@end
