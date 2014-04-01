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
static const CGFloat dateLabelFontSize  = 16.0;


@interface UTCSEventDetailViewController ()
@property (nonatomic) UITabBar  *headerTabBar;
@property (nonatomic) UTCSParallaxBlurHeaderScrollView  *parallaxBlurHeaderScrollView;

/**
 Label used to display the date of a news story
 */
@property (nonatomic) UILabel                           *locationLabel;

/**
 Text view used to display the news story
 */
@property (nonatomic) UITextView                        *descriptionTextView;

@end

@implementation UTCSEventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.parallaxBlurHeaderScrollView = [[UTCSParallaxBlurHeaderScrollView alloc]initWithFrame:self.view.bounds];
        self.parallaxBlurHeaderScrollView.headerImage = [UIImage imageNamed:@"header"];
        self.parallaxBlurHeaderScrollView.headerBlurredImage = [UIImage imageNamed:@"blurredHeader"];
        [self.view addSubview:self.parallaxBlurHeaderScrollView];
        
        self.locationLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0, self.parallaxBlurHeaderScrollView.headerContainerView.height - 1.5 * dateLabelFontSize, self.view.width - 16.0, 1.5 * dateLabelFontSize)];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:dateLabelFontSize];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.75];
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
        [self.parallaxBlurHeaderScrollView.headerContainerView addSubview:self.locationLabel];
        
        
        
        self.descriptionTextView = ({
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0.0, self.parallaxBlurHeaderScrollView.headerContainerView.height, self.view.width, 0.0)];
            textView.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber | UIDataDetectorTypeAddress;
            textView.textContainerInset = UIEdgeInsetsMake(64.0, 8.0, 8.0, 8.0);
            textView.textColor = [UIColor utcsGrayColor];
            textView.scrollEnabled = NO;
            textView.editable = NO;
            textView;
        });
        [self.parallaxBlurHeaderScrollView.scrollView addSubview:self.descriptionTextView];
        
        self.headerTabBar = ({
            UITabBar *tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0.0,
                                                                         self.parallaxBlurHeaderScrollView.headerContainerView.height,
                                                                         self.view.width, 64)];
            UITabBarItem *calendarItem = [[UITabBarItem alloc]initWithTitle:@"Add to Calender"
                                                                      image:[UIImage imageNamed:@"events"]
                                                              selectedImage:nil];
            UITabBarItem *starItem = [[UITabBarItem alloc]initWithTitle:@"Star"
                                                                  image:[UIImage imageNamed:@"star"]
                                                          selectedImage:nil];
            tabBar.items = @[calendarItem, starItem];
            tabBar.tintColor = [UIColor utcsBurntOrangeColor];
            tabBar;
        });
        [self.parallaxBlurHeaderScrollView.scrollView addSubview:self.headerTabBar];
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
    
    self.locationLabel.text = [NSString stringWithFormat:@"Location : %@", event.location];
    
    self.descriptionTextView.attributedText = event.attributedDescription;
    self.descriptionTextView.height = [self.descriptionTextView sizeForWidth:self.descriptionTextView.textContainer.size.width
                                                              height:CGFLOAT_MAX].height;
    
    self.parallaxBlurHeaderScrollView.scrollView.contentSize = CGSizeMake(self.parallaxBlurHeaderScrollView.width, self.descriptionTextView.height + self.parallaxBlurHeaderScrollView.headerContainerView.height + self.headerTabBar.height);
}

@end
