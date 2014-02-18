//
//  UTCSNewsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/18/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsViewController.h"

@interface UTCSNewsViewController ()
@property (strong, nonatomic) UITableView   *newsTableView;
@end

@implementation UTCSNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.newsTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.newsTableView];
}

@end
