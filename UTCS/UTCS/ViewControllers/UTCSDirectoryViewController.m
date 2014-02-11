//
//  UTCSDirectoryViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/8/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryViewController.h"

@interface UTCSDirectoryViewController ()

@end

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Directory";
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
