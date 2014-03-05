//
//  UTCSEventDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventDetailViewController.h"
#import "UTCSEvent.h"
#import "UITextView+CZTextViewHeight.h"
#import "UIColor+UTCSColors.h"
#import "UIView+Positioning.h"


#pragma mark UTCSEventDetailViewController Class Extension

@interface UTCSEventDetailViewController ()

//
@property (strong, nonatomic) UITextView        *titleTextView;

//
@property (strong, nonatomic) UILabel           *dateLabel;

//
@property (strong, nonatomic) UILabel           *locationLabel;

//
@property (strong, nonatomic) UITextView        *descriptionTextView;

//
@property (strong, nonatomic) UILabel           *contactLabel;

//
@property (strong, nonatomic) NSDateFormatter   *dateFormatter;

//
@property (strong, nonatomic) UIScrollView      *scrollView;

//
@property (strong, nonatomic) UIButton          *addToCalendarButton;

@end


#pragma mark UTCSEventDetailViewController Implementation

@implementation UTCSEventDetailViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Event";
        self.dateFormatter = ({
            NSDateFormatter *dateFormatter  = [NSDateFormatter new];
            dateFormatter.timeZone          = [NSTimeZone timeZoneWithName:@"GMT"];
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

    // Location label
    self.locationLabel = ({
        UILabel *label          = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font              = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        label.textColor         = [UIColor utcsLightGrayColor];
        label.backgroundColor   = [UIColor clearColor];
        label.numberOfLines     = 0;
        label;
    });
    [self.scrollView addSubview:self.locationLabel];
    
    // Add to calendar button
    self.addToCalendarButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.layer.cornerRadius = 6.0;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor utcsBurntOrangeColor].CGColor;
        button.layer.borderWidth = 1.0;
        button.tintColor = [UIColor utcsBurntOrangeColor];
        [button setTitle:@"Add to Calendar" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        button;
    });
    [self.scrollView addSubview:self.addToCalendarButton];
    
    // Description text view
    self.descriptionTextView = ({
        UITextView *textView        = [[UITextView alloc]initWithFrame:CGRectZero];
        textView.font               = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        textView.editable           = NO;
        textView.scrollEnabled      = NO;
        textView.textAlignment      = NSTextAlignmentLeft;
        textView.textColor          = [UIColor utcsGrayColor];
        textView.backgroundColor    = [UIColor clearColor];
        textView;
    });
    [self.scrollView addSubview:self.descriptionTextView];
    
    // Contact label
    self.contactLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor utcsLightGrayColor];
        label;
    });
    [self.scrollView addSubview:self.contactLabel];
}

#pragma mark Updating UI

- (void)updateWithEvent:(UTCSEvent *)event
{
    self.title                              = [self dateStringWithStartDate:event.startDate endDate:event.endDate title:YES];
    self.titleTextView.text                 = event.name;
    self.dateLabel.text                     = [self dateStringWithStartDate:event.startDate endDate:event.endDate title:NO];
    self.locationLabel.text                 = event.location;
    self.descriptionTextView.attributedText = event.attributedDescription;
    self.contactLabel.text                  = [NSString stringWithFormat:@"%@ - %@", event.contactName, event.contactEmail];
    [self updateSubviewLayouts];
}

- (void)updateSubviewLayouts
{
    self.scrollView.frame           = self.view.bounds;
    self.titleTextView.frame        = CGRectMake(16.0, 0.0, self.view.width - 32.0, [self.titleTextView heightForText]);
    self.dateLabel.frame            = CGRectMake(21.5, self.titleTextView.y + self.titleTextView.height + 4.0,
                                                 self.view.width - 43.0, self.dateLabel.font.pointSize);
    self.locationLabel.frame        = CGRectMake(21.5, self.dateLabel.y + self.dateLabel.height, self.view.width - 43.0, 32.0);
    self.addToCalendarButton.frame  = CGRectMake(16.0, self.locationLabel.y + self.locationLabel.height + 28.0, self.view.width - 32.0, 50.0);
    self.descriptionTextView.frame  = CGRectMake(16.0, self.addToCalendarButton.y + self.addToCalendarButton.height + 28.0,
                                                 self.view.width - 32.0, [self.descriptionTextView heightForText]);
    self.contactLabel.frame         = CGRectMake(0.0, self.descriptionTextView.y + self.descriptionTextView.height + 8.0,
                                                 self.view.width, self.contactLabel.font.pointSize);
    self.scrollView.contentSize     = CGSizeMake(self.view.width, self.contactLabel.y + 2.0 * self.contactLabel.height);
}

#pragma mark Private Methods

- (NSString *)dateStringWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(BOOL)title
{
    self.dateFormatter.dateFormat = @"MMM d";
    NSString *startDay = [self.dateFormatter stringFromDate:startDate];
    NSString *endDay = [self.dateFormatter stringFromDate:endDate];
    
    if([startDay isEqualToString:endDay]) {
        if(title) {
            return startDay;
        } else {
            self.dateFormatter.dateFormat = @"EEE MMM d, h:mm a";
            NSString *startTime = [self.dateFormatter stringFromDate:startDate];
            
            self.dateFormatter.dateFormat = @"h:mm a";
            NSString *endTime = [self.dateFormatter stringFromDate:endDate];
            
            return [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
        }
    } else {
        if(title) {
            self.dateFormatter.dateFormat = @"MMM d";
        } else {
            self.dateFormatter.dateFormat = @"MMM d, h:mm a";
        }
        NSString *startTime = [self.dateFormatter stringFromDate:startDate];
        NSString *endTime   = [self.dateFormatter stringFromDate:endDate];
        return [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    }
}

#pragma mark Overridden Setters

- (void)setEvent:(UTCSEvent *)event
{
    _event = event;
    [self updateWithEvent:_event];
}

@end
