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

@property (strong, nonatomic) NSCalendar        *currentCalendar;

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
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.titleTextView.height = [self.titleTextView heightForText];
    self.dateLabel.y = self.titleTextView.y + self.titleTextView.height + 4.0;
    self.locationLabel.y = self.dateLabel.y + self.dateLabel.height;
    self.contactLabel.y  = MAX(self.descriptionTextView.y + self.descriptionTextView.height + 8.0,
                               self.view.height - self.contactLabel.height - 68.0);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), self.contactLabel.y + self.contactLabel.height + 4.0);
}

- (void)initializeSubviews
{
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
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(16.0, 0.0, self.view.width, 0.0)];
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
    
    if(!self.dateLabel) {
        self.dateLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(21.5,
                                                                      self.titleTextView.y + self.titleTextView.height,
                                                                      self.view.width - 43.0,
                                                                      16.0)];
            label.font              = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
            label.textColor         = [UIColor utcsLightGrayColor];
            label.backgroundColor   = [UIColor clearColor];
            label;
        });
        [self.scrollView addSubview:self.dateLabel];
    }

    if(!self.locationLabel) {
        self.locationLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(21.5, self.dateLabel.y + self.dateLabel.height,
                                                                      self.view.width - 43.0, 32.0)];
            label.font              = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
            label.textColor         = [UIColor utcsLightGrayColor];
            label.backgroundColor   = [UIColor clearColor];
            label.numberOfLines     = 0;
            label;
        });
        [self.scrollView addSubview:self.locationLabel];
    }

    if(!self.descriptionTextView) {
        self.descriptionTextView = ({
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(16.0, self.locationLabel.y + self.locationLabel.height + 24.0, self.view.width - 32.0, 0.0)];
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
    
    if(!self.contactLabel) {
        self.contactLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.descriptionTextView.y + self.descriptionTextView.height + 8.0, self.view.width, 16.0)];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor utcsLightGrayColor];
            label;
        });
        [self.scrollView addSubview:self.contactLabel];
    }

}

#pragma mark Updating UI

- (void)updateWithEvent:(PFObject *)event
{
    self.title = [self dateStringWithStartDate:self.event[PARSE_EVENT_DATE_START] endDate:self.event[PARSE_EVENT_DATE_END] title:YES];
    
    self.titleTextView.text = self.event[PARSE_EVENT_NAME];
    
    self.dateLabel.text = [self dateStringWithStartDate:self.event[PARSE_EVENT_DATE_START]
                                                endDate:self.event[PARSE_EVENT_DATE_END]
                                                  title:NO];
    
    
    self.locationLabel.text     = self.event[PARSE_EVENT_LOCATION];
    
    NSMutableAttributedString *attributedEventDescription = [[NSMutableAttributedString alloc]initWithData:[self.event[PARSE_EVENT_DESCRIPTION] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                          documentAttributes:nil error:nil];
    [attributedEventDescription enumerateAttributesInRange:NSMakeRange(0, [attributedEventDescription length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock: ^ (NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIFont *font = attrs[NSFontAttributeName];
        NSString *fontName = [font.fontName lowercaseString];
        if([fontName rangeOfString:@"bold"].location != NSNotFound) {
            [attributedEventDescription addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
            [attributedEventDescription addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:16] range:range];
        } else {
            [attributedEventDescription addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range];
            [attributedEventDescription addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16] range:range];
        }
    }];
    
    self.descriptionTextView.attributedText = attributedEventDescription;
    
    if([self.descriptionTextView.text length] == 0) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:@"Description Unavailable"];
        NSRange range = NSMakeRange(0, [attributedText length]);
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:16] range:range];
        self.descriptionTextView.attributedText = attributedText;
    }
    CGRect descriptionTextViewFrame         = self.descriptionTextView.frame;
    descriptionTextViewFrame.origin.y       = self.locationLabel.y + self.locationLabel.height + 24.0;
    descriptionTextViewFrame.size.height    = [self.descriptionTextView heightForText];
    self.descriptionTextView.frame          = descriptionTextViewFrame;
    
    
    self.contactLabel.text      = [NSString stringWithFormat:@"Contact: %@ - %@",
                                   self.event[PARSE_EVENT_CONTACT_NAME],
                                   self.event[PARSE_EVENT_CONTACT_EMAIL]];
    [self viewWillLayoutSubviews];
}

#pragma mark Private Methods

- (NSString *)dateStringWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(BOOL)title
{
    if(!self.currentCalendar) {
        // This call is slow, so let's cache it
        self.currentCalendar = [NSCalendar currentCalendar];
    }
    
    NSDateComponents *componentsForFirstDate = [self.currentCalendar components:NSCalendarUnitMinute|NSCalendarUnitHour|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:startDate];
    NSDateComponents *componentsForSecondDate = [self.currentCalendar components:NSCalendarUnitMinute|NSCalendarUnitHour|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:endDate];
    
    if([componentsForFirstDate day] == [componentsForSecondDate day] &&
       [componentsForFirstDate month] == [componentsForSecondDate month] &&
       [componentsForFirstDate year] == [componentsForSecondDate year]) {
        if(title) {
            self.dateFormatter.dateFormat = @"MMM d";
            return [self.dateFormatter stringFromDate:startDate];
        }
        self.dateFormatter.dateFormat = @"EEE MMM d, h:mm a";
        NSString *startTime = [self.dateFormatter stringFromDate:startDate];
        self.dateFormatter.dateFormat = @"h:mm a";
        NSString *endTime = [self.dateFormatter stringFromDate:endDate];
        return [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    } else {
        if(title) {
            self.dateFormatter.dateFormat = @"MMM d";
        } else {
            self.dateFormatter.dateFormat = @"MMM d, h:mm a";
        }
        NSString *startTime = [self.dateFormatter stringFromDate:startDate];
        NSString *endTime = [self.dateFormatter stringFromDate:endDate];
        return [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    }
}

#pragma mark Overridden Setters

- (void)setEvent:(PFObject *)event
{
    _event = event;
    [self updateWithEvent:_event];
}

@end
