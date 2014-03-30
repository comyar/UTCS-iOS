//
//  UTCSEventsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsViewController.h"
#import "UTCSBackgroundHeaderBlurTableView.h"
#import "UTCSMenuButton.h"
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"

@interface UTCSEventsViewController ()

@property (nonatomic) UTCSBackgroundHeaderBlurTableView     *backgroundHeaderBlurTableView;

@end

@implementation UTCSEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundHeaderBlurTableView = [[UTCSBackgroundHeaderBlurTableView alloc]initWithFrame:self.view.bounds];
    self.backgroundHeaderBlurTableView.backgroundImage = [[UIImage imageNamed:@"eventsBackground"]tintedImageWithColor:[UIColor utcsImageTintColor] blendingMode:kCGBlendModeOverlay];
    self.backgroundHeaderBlurTableView.backgroundBlurredImage = [[UIImage imageNamed:@"eventsBackground-blurred"]tintedImageWithColor:[UIColor utcsImageTintColor] blendingMode:kCGBlendModeOverlay];
    self.backgroundHeaderBlurTableView.tableView.delegate = self;
    //    self.backgroundHeaderBlurTableView.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.backgroundHeaderBlurTableView];
}

@end
