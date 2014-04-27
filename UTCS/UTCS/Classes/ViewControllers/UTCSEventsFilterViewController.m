//
//  UTCSEventsFilterViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsFilterViewController.h"
#import "UIView+CZPositioning.h"

@interface UTCSEventsFilterViewController ()


@end

@implementation UTCSEventsFilterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuButton.hidden = YES;
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0.5;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
