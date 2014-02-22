//
//  UTCSLabsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsViewController.h"

#pragma mark - UTCSLabsViewController Class Extension

@interface UTCSLabsViewController ()

//
@property (strong, nonatomic) UIScrollView  *scrollView;

@end


#pragma mark - UTCSLabsViewController Implementation

@implementation UTCSLabsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
}

@end
