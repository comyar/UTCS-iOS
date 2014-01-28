//
//  UTCSMainViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 1/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsViewController.h"

@interface UTCSEventsViewController ()

@end

@implementation UTCSEventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Events";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
