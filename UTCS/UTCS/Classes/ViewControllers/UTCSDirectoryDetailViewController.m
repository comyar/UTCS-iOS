//
//  UTCSDirectoryDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryDetailViewController.h"

@interface UTCSDirectoryDetailViewController ()

@end

@implementation UTCSDirectoryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setPerson:(UTCSDirectoryPerson *)person
{
    _person = person;
    
    [self configureWithPerson:person];
}

- (void)configureWithPerson:(UTCSDirectoryPerson *)person
{
    
}


@end
