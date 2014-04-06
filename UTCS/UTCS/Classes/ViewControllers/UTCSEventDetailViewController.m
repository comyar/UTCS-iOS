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
static const CGFloat dateLabelFontSize  = 28.0;


@interface UTCSEventDetailViewController ()

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

@property (nonatomic) UIButton                          *scrollToTopButton;

@end

@implementation UTCSEventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.scrollToTopButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0.0, 0.0, self.view.width, 44);
            button;
        });
        self.navigationItem.titleView = self.scrollToTopButton;
        
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
        
        self.dateLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, self.parallaxBlurHeaderScrollView.headerContainerView.height - 80.0, self.parallaxBlurHeaderScrollView.headerContainerView.width - 16.0, 80.0)];
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
    
    self.dateLabel.attributedText = [self dateStringForStartDate:_event.startDate endDate:_event.endDate];
    
    self.locationLabel.text = _event.location;
    
    self.descriptionTextView.attributedText = ({
        NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
        
        NSString *nameString = [NSString stringWithFormat:@"%@\n\n", _event.name];
        NSAttributedString *name = [[NSAttributedString alloc]initWithString:nameString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:16], NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        [attributedText appendAttributedString:name];
        
        if(_event.location) {
            NSString *locationString = [NSString stringWithFormat:@"Location : %@\n\n", _event.location];
            NSAttributedString *location = [[NSAttributedString alloc]initWithString:locationString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16], NSForegroundColorAttributeName:[UIColor blackColor]}];
            [attributedText appendAttributedString:location];
        }
        
        if(_event.attributedDescription) {
            NSLog(@"asdfasdfasdf");
            NSAttributedString *descriptionHeader = [[NSAttributedString alloc]initWithString:@"Description\n\n" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:16], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
            
            [attributedText appendAttributedString:descriptionHeader];
            [attributedText appendAttributedString:_event.attributedDescription];
        } else {
            NSAttributedString *description = [[NSAttributedString alloc]initWithString:@"Description Unavailable\n" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
            [attributedText appendAttributedString:description];
        }
        
        attributedText;
    });
    
    self.descriptionTextView.height = [self.descriptionTextView sizeForWidth:self.descriptionTextView.textContainer.size.width
                                                              height:CGFLOAT_MAX].height;
    
    self.parallaxBlurHeaderScrollView.scrollView.contentSize = CGSizeMake(self.parallaxBlurHeaderScrollView.width, self.descriptionTextView.height + self.parallaxBlurHeaderScrollView.headerContainerView.height);
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.addToCalendarButton) {
        
    } else if(button == self.shareButton) {
        
    } else if(button == self.scrollToTopButton) {
        [self.parallaxBlurHeaderScrollView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (NSAttributedString *)dateStringForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSString *startDateString = [self.dateFormatter stringFromDate:startDate];
    NSString *endDateString = [self.dateFormatter stringFromDate:endDate];
    
    NSString *startTimeString = [NSDateFormatter localizedStringFromDate:startDate
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterShortStyle];
    
    NSString *endTimeString = [NSDateFormatter localizedStringFromDate:endDate
                                                             dateStyle:NSDateFormatterNoStyle
                                                             timeStyle:NSDateFormatterShortStyle];
    
    NSMutableAttributedString *attributedDateString = [NSMutableAttributedString new];
    
    NSAttributedString *attributedStartDate = [[NSAttributedString alloc]initWithString:startDateString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:36]}];
    [attributedDateString appendAttributedString:attributedStartDate];
    
    NSString *timeString = [NSString stringWithFormat:@"\n%@ - %@", startTimeString, endTimeString];
    NSAttributedString *attributedTime = [[NSAttributedString alloc]initWithString:timeString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:24], NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:0.8]}];
    
    if([startDateString isEqualToString:endDateString]) {
        [attributedDateString appendAttributedString:attributedTime];
    } else {
        [attributedDateString appendAttributedString:attributedStartDate];
        
        NSString *endDayString = [NSString stringWithFormat:@" - %@", [self.dayDateFormatter stringFromDate:endDate]];
        
        NSAttributedString *attributedEndDay = [[NSAttributedString alloc]initWithString:endDayString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:36]}];
        
        [attributedDateString appendAttributedString:attributedEndDay];
        [attributedDateString appendAttributedString:attributedTime];
    }
    return attributedDateString;
}

@end
