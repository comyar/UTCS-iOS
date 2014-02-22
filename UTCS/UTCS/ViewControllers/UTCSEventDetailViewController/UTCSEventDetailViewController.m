//
//  UTCSEventDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventDetailViewController.h"


#pragma mark UTCSEventDetailViewController Class Extension

@interface UTCSEventDetailViewController ()

//
@property (strong, nonatomic) UITextView        *titleTextView;

//
@property (strong, nonatomic) UITextView        *descriptionTextView;

//
@property (strong, nonatomic) NSDateFormatter   *dateFormatter;

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
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
}

#pragma mark Updating UI

- (void)updateWithEvent:(PFObject *)event
{
    self.title = [self.dateFormatter stringFromDate:self.event[PARSE_EVENT_DATE_START]];
    
    if(!self.titleTextView) {
        self.titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(16.0, 0.0, CGRectGetWidth(self.view.bounds) - 32.0, CGRectGetHeight(self.view.bounds))];
        self.titleTextView.textColor = COLOR_DARK_GRAY;
        self.titleTextView.editable = NO;
        self.titleTextView.scrollEnabled = NO;
        self.titleTextView.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
        self.titleTextView.textAlignment = NSTextAlignmentNatural;
        [self.scrollView addSubview:self.titleTextView];
    }
    
    self.titleTextView.text = self.event[PARSE_EVENT_NAME];
    
    
    if(!self.descriptionTextView) {
        self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(16.0, self.titleTextView.frame.origin.x + CGRectGetHeight(self.titleTextView.bounds), CGRectGetWidth(self.view.bounds) - 32.0, CGRectGetHeight(self.view.bounds))];
        self.descriptionTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        self.descriptionTextView.editable = NO;
        self.descriptionTextView.scrollEnabled = NO;
        self.descriptionTextView.textColor = COLOR_GRAY;
        [self.scrollView addSubview:self.descriptionTextView];
    }
    
    self.descriptionTextView.text = self.event[PARSE_EVENT_DESCRIPTION];
    
    
}

#pragma mark Overridden Setters

- (void)setEvent:(PFObject *)event
{
    _event = event;
    [self updateWithEvent:_event];
}

@end
