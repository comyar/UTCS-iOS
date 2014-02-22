//
//  UTCSDirectoryViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryViewController.h"

@interface UTCSDirectoryViewController ()

@property (strong, nonatomic) UISearchBar               *directorySearchBar;
@property (strong, nonatomic) UISearchDisplayController *directorySearchDisplayController;
@end

@implementation UTCSDirectoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.directorySearchBar becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.directorySearchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    self.directorySearchBar.placeholder = @"Search UTCS Directory";
    self.directorySearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.directorySearchBar contentsController:self];
    self.directorySearchDisplayController.displaysSearchBarInNavigationBar = YES;
}

@end
