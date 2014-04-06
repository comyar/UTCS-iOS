//
//  UTCSEventDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/30/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventDetailViewController.h"
#import "UTCSParallaxBlurHeaderScrollView.h"
#import "UTCSEvent.h"
#import "UIView+CZPositioning.h"
#import "UIColor+UTCSColors.h"
#import "UITextView+CZTextViewHeight.h"


/**
 Font size of the date label
 */
static const CGFloat dateLabelFontSize  = 32.0;


@interface UTCSEventDetailViewController ()

@property (nonatomic) UIView  *headerControlBar;

@property (nonatomic) UTCSParallaxBlurHeaderScrollView  *parallaxBlurHeaderScrollView;


@property (nonatomic) UILabel                           *dateLabel;

@property (nonatomic) NSDateFormatter                   *dateFormatter;

@property (nonatomic) NSDateFormatter                   *dayDateFormatter;

/**
 Label used to display the date of a news story
 */
@property (nonatomic) UILabel                           *locationLabel;

/**
 Text view used to display the news story
 */
@property (nonatomic) UITextView                        *descriptionTextView;

@property (nonatomic) UIButton                          *addToCalendarButton;

@property (nonatomic) UIButton                          *shareButton;

@end

@implementation UTCSEventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
        self.dateFormatter.dateFormat = @"EEEE, MMM d";
        
        self.dayDateFormatter = [NSDateFormatter new];
        self.dayDateFormatter.timeZone = [[NSTimeZone alloc]initWithName:@"GMT"];
        self.dayDateFormatter.dateFormat = @"d";
        
        self.parallaxBlurHeaderScrollView = [[UTCSParallaxBlurHeaderScrollView alloc]initWithFrame:self.view.bounds];
        self.parallaxBlurHeaderScrollView.headerImage = [UIImage imageNamed:@"header"];
        self.parallaxBlurHeaderScrollView.headerBlurredImage = [UIImage imageNamed:@"blurredHeader"];
        [self.view addSubview:self.parallaxBlurHeaderScrollView];
        
        
        
        self.locationLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, self.parallaxBlurHeaderScrollView.headerContainerView.height - 1.5 * dateLabelFontSize, self.view.width - 16.0, 1.5 * dateLabelFontSize)];
            label.numberOfLines = 1;
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:dateLabelFontSize];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.90];
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
        [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:self.locationLabel];
        
        self.dateLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, self.parallaxBlurHeaderScrollView.headerContainerView.height - self.locationLabel.height - 100.0, self.parallaxBlurHeaderScrollView.headerContainerView.width - 16.0, 80.0)];
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
            textView.textContainerInset = UIEdgeInsetsMake(128.0, 8.0, 8.0, 8.0);
            textView.textColor = [UIColor utcsGrayColor];
            textView.scrollEnabled = NO;
            textView.editable = NO;
            textView;
        });
        [self.parallaxBlurHeaderScrollView.scrollView addSubview:self.descriptionTextView];
        
        self.headerControlBar = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, self.parallaxBlurHeaderScrollView.headerContainerView.height, self.view.width, 64)];
            view.backgroundColor = [UIColor clearColor];
            
            self.addToCalendarButton = [self headerControlButtonWithTitle:@"Add To Calendar"];
            self.addToCalendarButton.centerX = 0.25 * view.width;
            
            self.shareButton = [self headerControlButtonWithTitle:@"Share"];
            self.shareButton.centerX = .75 * view.width;
            
            [view addSubview:self.shareButton];
            [view addSubview:self.addToCalendarButton];
            
            [self.parallaxBlurHeaderScrollView.scrollView addSubview:view];
            view;
        });
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setEvent:(UTCSEvent *)event
{
    _event = event;
    
    self.dateLabel.text = [self dateStringForStartDate:_event.startDate endDate:_event.endDate];
    
    self.locationLabel.text = _event.location;
    
    self.descriptionTextView.attributedText = event.attributedDescription;
    self.descriptionTextView.height = [self.descriptionTextView sizeForWidth:self.descriptionTextView.textContainer.size.width
                                                              height:CGFLOAT_MAX].height;
    
    self.parallaxBlurHeaderScrollView.scrollView.contentSize = CGSizeMake(self.parallaxBlurHeaderScrollView.width, self.descriptionTextView.height + self.parallaxBlurHeaderScrollView.headerContainerView.height + self.headerControlBar.height);
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    NSLog(@"yolo");
    if(button == self.addToCalendarButton) {
        
    } else if(button == self.shareButton) {
        
    }
}

- (NSString *)dateStringForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSString *startDateString = [self.dateFormatter stringFromDate:startDate];
    NSString *endDateString = [self.dateFormatter stringFromDate:endDate];
    
    NSString *startTimeString = [NSDateFormatter localizedStringFromDate:startDate
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterShortStyle];
    
    NSString *endTimeString = [NSDateFormatter localizedStringFromDate:endDate
                                                             dateStyle:NSDateFormatterNoStyle
                                                             timeStyle:NSDateFormatterShortStyle];
    
    NSString *dateString = nil;
    if([startDateString isEqualToString:endDateString]) {
        dateString = [NSString stringWithFormat:@"%@\n%@ - %@", startDateString, startTimeString, endTimeString];
    } else {
        NSString *endDayString = [self.dayDateFormatter stringFromDate:endDate];
        dateString = [NSString stringWithFormat:@"%@ - %@\n%@ - %@", startDateString, endDayString, startTimeString, endTimeString];
    }
    return dateString;
}

- (UIButton *)headerControlButtonWithTitle:(NSString *)title
{
    return ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(0, 0, 128, 64);
        
        UIImageView *imageView = ({
            NSString *imageName = [[title lowercaseString]stringByReplacingOccurrencesOfString:@" " withString:@""];
            UIImage *image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.tintColor = [UIColor blackColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(0, 0, 36, 36);
            imageView.center = CGPointMake(0.5 * button.width, 0.375 * button.height);
            imageView;
        });
        [button addSubview:imageView];
        
        UILabel *label = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 128, 16)];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor darkGrayColor];
            label.text = title;
            label;
        });
        [button addSubview:label];
        
        button;
    });
}

@end
