//
//  UTCSAboutViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAboutViewController.h"
#import "UIImage+CZTinting.h"
#import "UIView+CZPositioning.h"

@interface UTCSAboutViewController ()
@property (nonatomic) UITextView *textView;
@end

@implementation UTCSAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"About";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.0;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView = ({
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - 44.0)];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor whiteColor];
        textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        textView.editable = NO;
        textView.textContainerInset = UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0);
        [self.view addSubview:textView];
        textView;
    });
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"App-About" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = content;
}

@end
