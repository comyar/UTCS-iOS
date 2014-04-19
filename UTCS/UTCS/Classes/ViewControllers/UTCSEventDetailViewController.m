//
//  UTCSEventDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/30/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// View Controllers
#import "UTCSEventDetailViewController.h"

// Views
#import "UTCSParallaxBlurHeaderScrollView.h"

// Models
#import "UTCSEvent.h"

// Categories
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"
#import "UITextView+CZTextViewHeight.h"


#pragma mark - UIActivityViewController HideStatusBar Category

@implementation UIActivityViewController (HideStatusBar)

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end


#pragma mark - UTCSEventDetailViewController Class Extension

@interface UTCSEventDetailViewController ()

//
@property (nonatomic) UTCSParallaxBlurHeaderScrollView  *parallaxBlurHeaderScrollView;

//
@property (nonatomic) UILabel                           *dateLabel;

//
@property (nonatomic) NSDateFormatter                   *dateFormatter;

//
@property (nonatomic) NSDateFormatter                   *dayDateFormatter;

// Label used to display the date of a news story
@property (nonatomic) UILabel                           *locationLabel;

// Text view used to display the news story
@property (nonatomic) UITextView                        *descriptionTextView;

//
@property (nonatomic) UIButton                          *addToCalendarButton;

//
@property (nonatomic) UIButton                          *shareButton;

//
@property (nonatomic) UIButton                          *scrollToTopButton;

//
@property (nonatomic) EKEventStore                      *eventStore;

//
@property (nonatomic) UIActivityViewController          *activityViewController;

@end


#pragma mark - UTCSEventDetailViewController Implementation

@implementation UTCSEventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
        self.dateFormatter.dateFormat = @"EEEE, MMMM d";
        
        self.dayDateFormatter = [NSDateFormatter new];
        self.dayDateFormatter.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
        self.dayDateFormatter.dateFormat = @"d";
        
        self.parallaxBlurHeaderScrollView = [[UTCSParallaxBlurHeaderScrollView alloc]initWithFrame:self.view.bounds];
        self.parallaxBlurHeaderScrollView.headerImage = [UIImage imageNamed:@"header"];
        self.parallaxBlurHeaderScrollView.headerBlurredImage = [UIImage imageNamed:@"blurredHeader"];
        [self.view addSubview:self.parallaxBlurHeaderScrollView];
        
        self.dateLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, self.parallaxBlurHeaderScrollView.headerContainerView.height - 88.0, self.parallaxBlurHeaderScrollView.headerContainerView.width - 16.0, 80.0)];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:36];
            label.textColor = [UIColor whiteColor];
            label.adjustsFontSizeToFitWidth = YES;
            label.numberOfLines = 2;
            [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:label];
            label;
        });
        
        self.descriptionTextView = ({
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0.0, self.parallaxBlurHeaderScrollView.headerContainerView.height, self.view.width, 0.0)];
            textView.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber | UIDataDetectorTypeAddress;
            textView.textContainerInset = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
            textView.textColor = [UIColor utcsGrayColor];
            textView.scrollEnabled = NO;
            textView.editable = NO;
            textView;
        });
        [self.parallaxBlurHeaderScrollView.scrollView addSubview:self.descriptionTextView];
        
        self.addToCalendarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 20, 20);
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"addtocalendar"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            imageView.tintColor = [UIColor whiteColor];
            imageView.frame = button.bounds;
            [button addSubview:imageView];
            
            button;
        });
        
        self.shareButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 20, 20);
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"share"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            imageView.tintColor = [UIColor whiteColor];
            imageView.frame = button.bounds;
            [button addSubview:imageView];
            
            button;
        });
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spacer.width = 20.0;
        self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.shareButton],
                                                    spacer,
                                                    [[UIBarButtonItem alloc]initWithCustomView:self.addToCalendarButton]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollToTopButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0.0, 0.0, self.view.width, 44);
        button;
    });
    self.navigationItem.titleView = self.scrollToTopButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setEvent:(UTCSEvent *)event
{
    _event = event;
    
    self.dateLabel.attributedText = [self dateStringForEvent:_event];
    
    self.locationLabel.text = _event.location;
    
    self.descriptionTextView.attributedText = ({
        NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
        
        NSString *nameString = [NSString stringWithFormat:@"%@ \n\n", _event.name];
        NSAttributedString *name = [[NSAttributedString alloc]initWithString:nameString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:16], NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        [attributedText appendAttributedString:name];
        
        if(_event.location) {
            NSString *locationString = [NSString stringWithFormat:@"%@ \n\n", _event.location];
            NSAttributedString *location = [[NSAttributedString alloc]initWithString:locationString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
            [attributedText appendAttributedString:location];
        }
        
        if(_event.attributedDescription) {
            NSAttributedString *descriptionHeader = [[NSAttributedString alloc]initWithString:@"Description \n\n" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:16], NSForegroundColorAttributeName:[UIColor utcsBurntOrangeColor]}];
            
            [attributedText appendAttributedString:descriptionHeader];
            [attributedText appendAttributedString:_event.attributedDescription];
        } else {
            NSAttributedString *description = [[NSAttributedString alloc]initWithString:@"Description Unavailable \n" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
            [attributedText appendAttributedString:description];
        }
        
        attributedText;
    });
    
    self.descriptionTextView.height = [self.descriptionTextView sizeForWidth:self.descriptionTextView.textContainer.size.width
                                                              height:CGFLOAT_MAX].height + self.descriptionTextView.textContainerInset.top + self.descriptionTextView.textContainerInset.bottom;
    self.descriptionTextView.height = MAX(self.descriptionTextView.height, 160);
    
    self.parallaxBlurHeaderScrollView.scrollView.contentSize = CGSizeMake(self.parallaxBlurHeaderScrollView.width, self.descriptionTextView.height + self.parallaxBlurHeaderScrollView.headerContainerView.height);
}

#pragma mark Share

- (void)sharedEvent:(UTCSEvent *)event
{
    
}

#pragma mark Calendar

- (void)addEventToCalendar:(UTCSEvent *)event
{
    
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.addToCalendarButton) {
        [self addEventToCalendar:self.event];
        
    } else if(button == self.shareButton) {
        [self sharedEvent:self.event];
        
    } else if(button == self.scrollToTopButton) {
        [self.parallaxBlurHeaderScrollView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (NSAttributedString *)dateStringForEvent:(UTCSEvent *)event
{
    return nil;
}

@end
