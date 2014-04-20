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


#pragma mark - UTCSEventDetailViewController Class Extension

@interface UTCSEventDetailViewController ()

//
@property (nonatomic) NSCalendar                        *calendar;

//
@property (nonatomic) NSDateFormatter                   *startDateFormatter;

//
@property (nonatomic) CAShapeLayer                      *contactSeparationLayer;

// -----
// @name Views
// -----

//
@property (nonatomic) UILabel                           *nameLabel;

//
@property (nonatomic) UILabel                           *dateLabel;

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
@property (nonatomic) UTCSParallaxBlurHeaderScrollView  *parallaxBlurHeaderScrollView;

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
    
    // Title label
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, 0.0, self.view.width - 16.0, 0.0)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 0;
        label;
    });
    [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:self.nameLabel];
    
    // Location label
    self.locationLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, kUTCSParallaxBlurHeaderHeight - 56.0, self.view.width - 16.0, 24.0)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 2;
        [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:label];
        label;
    });
    
    // Date label
    self.dateLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, kUTCSParallaxBlurHeaderHeight - 32.0, self.view.width - 16.0, 32.0)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
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
    
    // Share/Add to calendar buttons
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
    self.dateLabel.text     = [self dateStringForEvent:event];
    if (!self.dateLabel.text) {
        self.dateLabel.height = 0.0;
    } else {
        self.dateLabel.height = 32.0;
    }
    
    self.locationLabel.text = event.location;
    if (!self.locationLabel.text) {
        self.locationLabel.height = 0.0;
    } else {
        self.locationLabel.height = 24.0;
    }
    
    // Choose header image
    self.parallaxBlurHeaderScrollView.headerImage           = [UIImage imageNamed:@"header"];
    self.parallaxBlurHeaderScrollView.headerBlurredImage    = [UIImage imageNamed:@"blurredHeader"];
    
    
    // Configure name label
    self.nameLabel.frame = CGRectMake(8.0, 0.0, self.view.width - 16.0, 0.0); // Reset the frame, then downsize again with sizeToFit
    self.nameLabel.text = event.name;
    [self.nameLabel sizeToFit];
    if(self.nameLabel.height > kUTCSParallaxBlurHeaderHeight - 44.0 - self.dateLabel.height - self.locationLabel.height) {
        self.nameLabel.height = kUTCSParallaxBlurHeaderHeight - 44.0 - self.dateLabel.height - self.locationLabel.height;
    }
    self.nameLabel.y = self.locationLabel.y - self.nameLabel.height;

    // Configure description text view
    self.descriptionTextView.attributedText = [self descriptionForEvent:event];
    self.descriptionTextView.height = [self.descriptionTextView sizeForWidth:self.descriptionTextView.textContainer.size.width
                                                              height:CGFLOAT_MAX].height + self.descriptionTextView.textContainerInset.top + self.descriptionTextView.textContainerInset.bottom;
    self.descriptionTextView.y = kUTCSParallaxBlurHeaderHeight;
    
    // Set parallax blur header scroll view content size
    self.parallaxBlurHeaderScrollView.scrollView.contentSize = CGSizeMake(self.parallaxBlurHeaderScrollView.width, self.descriptionTextView.height + kUTCSParallaxBlurHeaderHeight);
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

- (NSAttributedString *)descriptionForEvent:(UTCSEvent *)event
{
    NSMutableAttributedString *attributedDescription = [NSMutableAttributedString new];
    
    if (event.attributedDescription) {
        NSMutableAttributedString *descriptionTitle = [[NSMutableAttributedString alloc]initWithString:@"Description\n\n"];
        
        [descriptionTitle addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor utcsBurntOrangeColor]
                                 range:NSMakeRange(0, [descriptionTitle length])];
        
        [descriptionTitle addAttribute:NSFontAttributeName
                                    value:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                    range:NSMakeRange(0, [descriptionTitle length])];
 
        [attributedDescription appendAttributedString:descriptionTitle];
        [attributedDescription appendAttributedString:event.attributedDescription];
        
    } else {
        NSMutableAttributedString *noDescriptionString = [[NSMutableAttributedString alloc]initWithString:@"Description Unavailable"];
        
        [noDescriptionString addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithWhite:0.5 alpha:0.5]
                                    range:NSMakeRange(0, [noDescriptionString length])];
        
        [noDescriptionString addAttribute:NSFontAttributeName
                                    value:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                    range:NSMakeRange(0, [noDescriptionString length])];
        
        [attributedDescription appendAttributedString:noDescriptionString];
    }
    
    return attributedDescription;
}

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
