//
//  UTCSEventDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/30/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSEvent.h"
#import "UTCSStateManager.h"
#import "UIColor+UTCSColors.h"
#import "UIButton+UTCSButton.h"
#import "NSString+CZContains.h"
#import "UIView+CZPositioning.h"
#import "UTCSStarredEventsManager.h"
#import "UITextView+CZTextViewHeight.h"
#import "UTCSEventsDetailViewController.h"


#pragma mark - Constants

// Name of the star icon image
static NSString * const starImageName           = @"star";

// Name of the filled-in star icon image
static NSString * const starActiveImageName     = @"star-active";

// Name of the share icon image
static NSString * const shareImageName          = @"share";

// Font name of the name label
static NSString * const nameLabelFontName       = @"HelveticaNeue-Bold";

// Font name of the location label
static NSString * const locationLabelFontName   = @"HelveticaNeue";

// Font name of the date label
static NSString * const dateLabelFontName       = @"HelveticaNeue";

// Font size of the name label
static const CGFloat nameLabelFontSize          = 22.0;

// Font size of the location label
static const CGFloat locationLabelFontSize      = 18.0;

// Font size of the date label
static const CGFloat dateLabelFontSize          = 18.0;


#pragma mark - UTCSEventsDetailViewController Class Extension

@interface UTCSEventsDetailViewController ()

// YES if the view controller has initialized the subviews
@property (nonatomic) BOOL                              hasInitializedSubviews;

// Current calendar
@property (nonatomic) NSCalendar                        *calendar;

// Date formatter for the event start date
@property (nonatomic) NSDateFormatter                   *startDateFormatter;

// Mapping of event location to header image names
@property (nonatomic) NSDictionary                      *headerImageMapping;

// Default headers to use if a header image/location mapping isn't found
@property (nonatomic) NSArray                           *defaultHeaderImages;

// Label used to display the name of the event
@property (nonatomic) UILabel                           *nameLabel;

// Label used to display the date of the event
@property (nonatomic) UILabel                           *dateLabel;

// Label used to display the date of the event
@property (nonatomic) UILabel                           *locationLabel;

// Text view used to display the event
@property (nonatomic) UITextView                        *descriptionTextView;

// Button used to share the event
@property (nonatomic) UIButton                          *shareButton;

// Button used to star events
@property (nonatomic) UIButton                          *starButton;

// Image view of the star button
@property (nonatomic) UIImageView                       *starButtonImageView;

// Button used to scroll to the top of the event detail
@property (nonatomic) UIButton                          *scrollToTopButton;

// Scroll view used to display the details of the event
@property (nonatomic) ParallaxBlurHeaderScrollView  *parallaxBlurHeaderScrollView;

@end


#pragma mark - UIActivityViewController Category (UTCSHideStatusBar)

@implementation UIActivityViewController (UTCSHideStatusBar)

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end


#pragma mark - UTCSEventsDetailViewController Implementation

@implementation UTCSEventsDetailViewController

#pragma mark Creating an Events Detail View Controller

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
        
        self.defaultHeaderImages = @[@"gdc-speedway"];
        self.headerImageMapping = @{@"1.304":@"gdc-1,304",
                                    @"1.406":@"gdc-1,406",
                                    @"2.410":@"gdc-2,410",
                                    @"5.302":@"gdc-5,302",
                                    @"5.304":@"gdc-5,304",
                                    @"6.102":@"gdc-6,102",
                                    @"6.302":@"gdc-6,302",
                                    @"auditorium":@"gdc-auditorium",
                                    @"atrium":@"gdc-atrium"};
    }
    return self;
}

- (void)initializeSubviews
{
    self.parallaxBlurHeaderScrollView = [[ParallaxBlurHeaderScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.parallaxBlurHeaderScrollView];
    
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, 0.0, self.view.width - 16.0, 0.0)];
        label.font = [UIFont fontWithName:nameLabelFontName size:nameLabelFontSize];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.shadowOffset = CGSizeMake(0.0, 0.5);
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 0;
        label;
    });
    [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:self.nameLabel];
    
    
    self.locationLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, kUTCSParallaxBlurHeaderHeight - 24.0, self.view.width - 16.0, 20.0)];
        label.font = [UIFont fontWithName:locationLabelFontName size:locationLabelFontSize];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        label.shadowOffset = CGSizeMake(0.0, 0.5);
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 2;
        label;
    });
    [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:self.locationLabel];
    
    
    self.dateLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, kUTCSParallaxBlurHeaderHeight - 48.0, self.view.width - 16.0, 20.0)];
        label.font = [UIFont fontWithName:dateLabelFontName size:dateLabelFontSize];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        label.shadowOffset = CGSizeMake(0.0, 0.5);
        label.adjustsFontSizeToFitWidth = YES;
        label;
    });
    [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:self.dateLabel];
    
    
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
    
    
    self.starButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(0, 0, 44, 44);
        
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.starButtonImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:starImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            imageView.tintColor = [UIColor whiteColor];
            imageView.frame = button.bounds;
            imageView;
        });
        
        [button addSubview:self.starButtonImageView];
        button;
    });
    
    
    self.shareButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.showsTouchWhenHighlighted = YES;
        
        button.frame = CGRectMake(0, 0, 44, 44);
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:shareImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        imageView.tintColor = [UIColor whiteColor];
        imageView.center = CGPointMake(0.5 * CGRectGetWidth(button.bounds), 0.5 * CGRectGetHeight(button.bounds));
        
        
        [button addSubview:imageView];
        button;
    });
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.shareButton],
                                                [[UIBarButtonItem alloc]initWithCustomView:self.starButton]];
    
    self.scrollToTopButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0.0, 0.0, self.view.width, 44);
        button;
    });
    self.navigationItem.titleView = self.scrollToTopButton;
}

#pragma mark Using an Events Detail View Controller

- (void)configureWithEvent:(UTCSEvent *)event
{
    self.dateLabel.text     = [self dateStringForEvent:event];
    if (!self.dateLabel.text) {
        self.dateLabel.height = 0.0;
    } else {
        self.dateLabel.height = 20.0;
    }
    
    self.locationLabel.text = event.location;
    if (!self.locationLabel.text) {
        self.locationLabel.height = 0.0;
    } else {
        self.locationLabel.height = 20.0;
    }
    
    // Choose header image
    NSString *headerImageName           = [self headerImageNameForEvent:event];
    self.parallaxBlurHeaderScrollView.headerImage           = [UIImage imageNamed:headerImageName];
    
    // Configure star button
    if ([[UTCSStarredEventsManager sharedManager]containsEvent:event]) {
        self.starButtonImageView.image = [[UIImage imageNamed:starActiveImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        self.starButtonImageView.image = [[UIImage imageNamed:starImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    // Configure name label
    self.nameLabel.frame = CGRectMake(8.0, kUTCSParallaxBlurNavigationBarHeight, self.view.width - 16.0, 0.0); // Reset the frame, then downsize again with sizeToFit
    self.nameLabel.text = event.name;
    [self.nameLabel sizeToFit];
    if(self.nameLabel.height > kUTCSParallaxBlurHeaderHeight - kUTCSParallaxBlurNavigationBarHeight - self.dateLabel.height - self.locationLabel.height - 4.0) {
        self.nameLabel.height = kUTCSParallaxBlurHeaderHeight - kUTCSParallaxBlurNavigationBarHeight - self.dateLabel.height - self.locationLabel.height - 4.0;
    }
    self.nameLabel.y = self.dateLabel.y - self.nameLabel.height - 4.0;

    // Configure description text view
    self.descriptionTextView.attributedText = [self descriptionForEvent:event];
    
    CGFloat descriptionTextViewHeight = [self.descriptionTextView sizeForWidth:self.descriptionTextView.textContainer.size.width
                                                                         height:CGFLOAT_MAX].height;
    descriptionTextViewHeight += self.descriptionTextView.textContainerInset.top + self.descriptionTextView.textContainerInset.bottom;
    self.descriptionTextView.height = MAX(descriptionTextViewHeight, 150.0);
    
    self.descriptionTextView.y = kUTCSParallaxBlurHeaderHeight;
    
    // Set parallax blur header scroll view content size
    self.parallaxBlurHeaderScrollView.scrollView.contentSize = CGSizeMake(self.parallaxBlurHeaderScrollView.width, self.descriptionTextView.height + kUTCSParallaxBlurHeaderHeight);
}

#pragma mark UIViewController Methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.parallaxBlurHeaderScrollView.scrollView.contentOffset = CGPointMake(0.0, 0.0);
}

#pragma mark Setters

- (void)setEvent:(UTCSEvent *)event
{
    _event = event;
    
    if (!self.hasInitializedSubviews) {
        [self initializeSubviews];
        self.hasInitializedSubviews = YES;
    }
    
    [self configureWithEvent:self.event];
}

#pragma mark Share Event

- (void)shareEvent:(UTCSEvent *)event
{
    NSMutableArray *activityItems = [NSMutableArray new];
    
    if (event.name) {
        [activityItems addObject:[event.name stringByAppendingString:@"\n"]];
    }
    
    if (event.location) {
        [activityItems addObject:[event.location stringByAppendingString:@""]];
    }
    
    if (self.dateLabel.text) {
        [activityItems addObject:[self.dateLabel.text stringByAppendingString:@"\n"]];
    }
    
    if (event.link) {
        [activityItems addObject:event.link];
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                                                                        applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark Star Event

- (void)updateEventStar:(UTCSEvent *)event
{
        self.starButtonImageView.image = [[UIImage imageNamed:starImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [[UTCSStarredEventsManager sharedManager]removeEvent:event];
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.shareButton) {
        [self shareEvent:self.event];
    } else if(button == self.scrollToTopButton) {
        [self.parallaxBlurHeaderScrollView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    } else if (self.starButton) {
        [self updateEventStar:self.event];
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

- (NSString *)headerImageNameForEvent:(UTCSEvent *)event
{
    NSString *location = event.location;
    
    if ([location contains:@"gdc"]) {
        for (NSString *key in self.headerImageMapping) {
            if([location contains:key]) {
                return self.headerImageMapping[key];
            }
        }
    }
    
    NSInteger index = arc4random() % [self.defaultHeaderImages count];
    return self.defaultHeaderImages[index];
}

@end
