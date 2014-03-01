//
//  UTCSEventDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventDetailViewController.h"
#import "UITextView+CZTextViewHeight.h"
#import "UIColor+UTCSColors.h"
#import "UIView+FrameBounds.h"


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

@end


#pragma mark UTCSEventDetailViewController Implementation

@implementation UTCSEventDetailViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Event";
        self.dateFormatter = ({
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"MMM d";
            dateFormatter;
        });
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

#pragma mark Updating UI

- (void)updateWithEvent:(PFObject *)event
{
    self.title = [self dateStringWithStartDate:self.event[PARSE_EVENT_DATE_START] endDate:self.event[PARSE_EVENT_DATE_END]];
    
    if(!self.scrollView) {
        self.scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
            scrollView.alwaysBounceVertical = YES;
            scrollView;
        });
        [self.view addSubview:self.scrollView];
    }
    
    if(!self.titleTextView) {
        self.titleTextView = ({
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(16.0, 0.0, self.view.width - 32.0, 0.0)];
            textView.textColor = [UIColor utcsDarkGrayColor];
            textView.editable = NO;
            textView.scrollEnabled = NO;
            textView.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
            textView.textAlignment = NSTextAlignmentLeft;
            textView.backgroundColor = [UIColor clearColor];
            textView;
        });
        [self.scrollView addSubview:self.titleTextView];
    }
    self.titleTextView.text         = self.event[PARSE_EVENT_NAME];
    CGRect titleTextViewFrame       = self.titleTextView.frame;
    titleTextViewFrame.size.height  = [self.titleTextView heightForText];
    self.titleTextView.frame        = titleTextViewFrame;
    
    if(!self.dateLabel) {
        self.dateLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(21.5, self.titleTextView.frameY + self.titleTextView.height,
                                                                      self.view.width - 43.0, 16.0)];
            label.font              = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
            label.textColor         = [UIColor utcsLightGrayColor];
            label.backgroundColor   = [UIColor clearColor];
            label;
        });
        [self.scrollView addSubview:self.dateLabel];
    }
    self.dateLabel.text     = [self dateStringWithStartDate:self.event[PARSE_EVENT_DATE_START] endDate:self.event[PARSE_EVENT_DATE_END]];
    CGRect dateLabelFrame   = self.dateLabel.frame;
    dateLabelFrame.origin.y = self.titleTextView.frameY + self.titleTextView.height + 4.0;
    self.dateLabel.frame    = dateLabelFrame;
    
    if(!self.locationLabel) {
        self.locationLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(21.5, self.dateLabel.frameY + self.dateLabel.height,
                                                                      self.view.width - 43.0, 32.0)];
            label.font              = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
            label.textColor         = [UIColor utcsLightGrayColor];
            label.backgroundColor   = [UIColor clearColor];
            label.numberOfLines     = 0;
            label;
        });
        [self.scrollView addSubview:self.locationLabel];
    }
    self.locationLabel.text     = self.event[PARSE_EVENT_LOCATION];
    CGRect locationLabelFrame   = self.locationLabel.frame;
    locationLabelFrame.origin.y = self.dateLabel.frameY + self.dateLabel.height;
    self.locationLabel.frame    = locationLabelFrame;
    
    
    if(!self.descriptionTextView) {
        self.descriptionTextView = ({
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(16.0, self.locationLabel.frameY + self.locationLabel.height + 24.0, self.view.width - 32.0, 0.0)];
            textView.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
            textView.editable = NO;
            textView.scrollEnabled = NO;
            textView.textAlignment = NSTextAlignmentLeft;
            textView.textColor = [UIColor utcsGrayColor];
            textView.backgroundColor = [UIColor clearColor];
            
            textView;
        });
        [self.scrollView addSubview:self.descriptionTextView];
    }
    
    self.descriptionTextView.text = self.event[PARSE_EVENT_DESCRIPTION];
    if([self.descriptionTextView.text length] == 0) {
        self.descriptionTextView.text = @"No Description Available";
    }
    CGRect descriptionTextViewFrame         = self.descriptionTextView.frame;
    descriptionTextViewFrame.origin.y       = self.locationLabel.frameY + self.locationLabel.height + 24.0;
    descriptionTextViewFrame.size.height    = [self.descriptionTextView heightForText];
    self.descriptionTextView.frame          = descriptionTextViewFrame;
    
    if(!self.contactLabel) {
        self.contactLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.descriptionTextView.frameY + self.descriptionTextView.height + 8.0, self.view.width, 16.0)];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor utcsLightGrayColor];
            label;
        });
        [self.scrollView addSubview:self.contactLabel];
    }
    self.contactLabel.text      = [NSString stringWithFormat:@"Contact: %@ - %@", @"CONTACT NAME", @"CONTACT EMAIL"];
    CGRect contactLabelFrame    = self.contactLabel.frame;
    contactLabelFrame.origin.y  = MAX(self.descriptionTextView.frameY + self.descriptionTextView.height + 8.0,
                                      self.view.height - self.contactLabel.height - 68.0);
    self.contactLabel.frame     = contactLabelFrame;
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), self.contactLabel.frameY + self.contactLabel.height + 4.0);
}

#pragma mark Private Methods

- (NSString *)dateStringWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSString *startDateString = [self.dateFormatter stringFromDate:startDate];
    NSString *endDateString = [self.dateFormatter stringFromDate:endDate];
    return [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString];
}

#pragma mark Overridden Setters

- (void)setEvent:(PFObject *)event
{
    _event = event;
    [self updateWithEvent:_event];
}

@end
