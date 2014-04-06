//
//  UTCSLicenseDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLicenseDetailViewController.h"
#import "UIView+CZPositioning.h"

@interface UTCSLicenseDetailViewController ()
@property (nonatomic) UITextView *textView;
@end

@implementation UTCSLicenseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor clearColor];
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

- (void)setLicense:(NSString *)license
{
    _license = license;
    self.title = _license;
    NSString *licenseFile = [NSString stringWithFormat:@"LICENSE-%@", _license];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:licenseFile ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = content;
}

@end
