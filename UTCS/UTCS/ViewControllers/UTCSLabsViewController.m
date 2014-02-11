//
//  UTCSLabsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/8/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsViewController.h"

@interface UTCSLabsViewController ()

@end

@implementation UTCSLabsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Labs";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
