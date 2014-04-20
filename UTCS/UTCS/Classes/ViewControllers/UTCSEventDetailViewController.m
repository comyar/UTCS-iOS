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
    // Hide the status bar on a UIActivityViewController
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

// Label used to display the date of the event
@property (nonatomic) UILabel                           *locationLabel;

// Text view used to display the event
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
@property (nonatomic) NSCalendar                        *calendar;

@property (nonatomic) NSDateFormatter                   *startDateFormatter;

//
@property (nonatomic) UIActivityViewController          *activityViewController;

@end


#pragma mark - UTCSEventDetailViewController Implementation

@implementation UTCSEventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor whiteColor];
        self.startDateFormatter = ({
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"MMM d, h:mm a";
            dateFormatter;
        });
    }
    return self;
}

- (void)initializeSubviews
{
    self.parallaxBlurHeaderScrollView = [[UTCSParallaxBlurHeaderScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.parallaxBlurHeaderScrollView];
    
    // Location label
    self.locationLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, kUTCSParallaxBlurHeaderHeight - 88.0, self.view.width - 16.0, 80.0)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 2;
        [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:label];
        label;
    });
    
    // Date label
    self.dateLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, kUTCSParallaxBlurHeaderHeight - 40.0, self.view.width - 16.0, 40.0)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:label];
        label;
    });
    
    
    // Description text view
    self.descriptionTextView = ({
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0.0, kUTCSParallaxBlurHeaderHeight, self.view.width, 0.0)];
        textView.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber | UIDataDetectorTypeAddress;
        textView.textContainerInset = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
        textView.textColor = [UIColor utcsGrayColor];
        textView.scrollEnabled = NO;
        textView.editable = NO;
        textView;
    });
    [self.parallaxBlurHeaderScrollView.scrollView addSubview:self.descriptionTextView];
    
    // Add to calendar button
    self.addToCalendarButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 20, 20);
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"events"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        imageView.tintColor = [UIColor whiteColor];
        imageView.frame = button.bounds;
        [button addSubview:imageView];
        button;
    });
    
    // Share button
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
    
    UIBarButtonItem *spacer = ({
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                      target:nil
                                                                                      action:nil];
        barButtonItem.width = 20.0;
        barButtonItem;
    });
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.shareButton],spacer,
                                                [[UIBarButtonItem alloc]initWithCustomView:self.addToCalendarButton]];
    
    // Scroll to top button
    self.scrollToTopButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0.0, 0.0, self.view.width, 44);
        self.navigationItem.titleView = button;
        button;
    });
}

- (void)configureWithEvent:(UTCSEvent *)event
{
    self.locationLabel.text = event.location;
    self.dateLabel.text = [self dateStringForEvent:event];
    
    // Choose header image
    self.parallaxBlurHeaderScrollView.headerImage           = [UIImage imageNamed:@"header"];
    self.parallaxBlurHeaderScrollView.headerBlurredImage    = [UIImage imageNamed:@"blurredHeader"];
    
    
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark Setters

- (void)setEvent:(UTCSEvent *)event
{
    _event = event;
    
    if ([self.view.subviews count] == 0) {
        [self initializeSubviews];
    }
    
    [self configureWithEvent:self.event];
}

#pragma mark Share

- (void)shareEvent:(UTCSEvent *)event
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
        [self shareEvent:self.event];
        
    } else if(button == self.scrollToTopButton) {
        [self.parallaxBlurHeaderScrollView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

#pragma mark Helper

- (NSString *)dateStringForEvent:(UTCSEvent *)event
{
    // All day event
    if (event.allDay) {
        
        NSString *startDateString = [NSDateFormatter localizedStringFromDate:event.startDate
                                                                   dateStyle:NSDateFormatterLongStyle
                                                                   timeStyle:NSDateFormatterNoStyle];
        
        NSString *combinedDateString = [NSString stringWithFormat:@"%@ - All Day", startDateString];
        return combinedDateString;
    }
    
    // Initialize calendar
    if (!self.calendar) {
        self.calendar = [NSCalendar currentCalendar];
    }
    
    // Find difference in days between start date and end date
    NSDateComponents *components = [self.calendar components:NSCalendarUnitDay
                                                    fromDate:event.startDate
                                                      toDate:event.endDate
                                                     options:NSWrapCalendarComponents];
    
    // Default to using the endDateString for a same day event
    NSString *startDateString = [self.startDateFormatter stringFromDate:event.startDate];
    NSString *endDateString = [NSDateFormatter localizedStringFromDate:event.endDate
                                                             dateStyle:NSDateFormatterNoStyle
                                                             timeStyle:NSDateFormatterShortStyle];
    
    // If the event is over multiple days, update the endDateString
    if ([components day] > 0) {
        endDateString = [NSDateFormatter localizedStringFromDate:event.endDate
                                                       dateStyle:NSDateFormatterMediumStyle
                                                       timeStyle:NSDateFormatterShortStyle];
    }
    
    // Combine the date strings and create attributed string
    NSString *combinedDateString = [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString];
    
    return combinedDateString;
}

@end
