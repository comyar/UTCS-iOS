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
#import "UTCSEventsManager.h"
#import "UTCSEvent.h"
#import "UIView+CZPositioning.h"
#import "UTCSEventDetailViewController.h"

@interface UTCSEventsViewController ()

@property (nonatomic) UTCSBackgroundHeaderBlurTableView     *backgroundHeaderBlurTableView;

@property (nonatomic) UTCSEventsManager *eventManager;

@property (nonatomic) BOOL hasAppeared;

@property (nonatomic) UTCSMenuButton *menuButton;

@property (nonatomic) UTCSEventDetailViewController *eventDetailViewController;
 
@end

@implementation UTCSEventsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.eventManager = [UTCSEventsManager new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundHeaderBlurTableView = [[UTCSBackgroundHeaderBlurTableView alloc]initWithFrame:self.view.bounds];
    self.backgroundHeaderBlurTableView.backgroundImage = [[UIImage imageNamed:@"eventsBackground"]tintedImageWithColor:[UIColor utcsImageTintColor] blendingMode:kCGBlendModeOverlay];
    self.backgroundHeaderBlurTableView.backgroundBlurredImage = [[UIImage imageNamed:@"eventsBackground-blurred"]tintedImageWithColor:[UIColor utcsImageTintColor] blendingMode:kCGBlendModeOverlay];
    self.backgroundHeaderBlurTableView.tableView.delegate = self;
    self.backgroundHeaderBlurTableView.tableView.dataSource = self.eventManager;
    [self.view addSubview:self.backgroundHeaderBlurTableView];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(8, 8, 56, 32)];
    [self.view addSubview:self.menuButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(!self.hasAppeared) {
        self.hasAppeared = YES;
        [self.eventManager updateEventsWithCompletion:^{
            [self.backgroundHeaderBlurTableView.tableView reloadData];
        }];
    }
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEvent *event = self.eventManager.events[indexPath.row];
    CGRect rect = [event.name boundingRectWithSize:CGSizeMake(self.backgroundHeaderBlurTableView.tableView.width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                                context:nil];
    return ceilf(rect.size.height) + 36.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEvent *event = self.eventManager.events[indexPath.row];
    self.eventDetailViewController = [UTCSEventDetailViewController new];
    self.eventDetailViewController.event = event;
    [self.navigationController pushViewController:self.eventDetailViewController animated:YES];
}


@end
