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
#import "FBShimmeringView.h"

@interface UTCSEventsViewController ()

@property (nonatomic) UTCSBackgroundHeaderBlurTableView     *backgroundHeaderBlurTableView;

@property (nonatomic) UTCSEventsManager *eventManager;

@property (nonatomic) BOOL hasAppeared;

@property (nonatomic) UTCSMenuButton *menuButton;

@property (nonatomic) UTCSEventDetailViewController *eventDetailViewController;

//
@property (nonatomic) FBShimmeringView                      *utcsEventsShimmeringView;

//
@property (nonatomic) UILabel                               *descriptionLabel;

//
@property (nonatomic) UILabel                               *updatedLabel;
 
@end

@implementation UTCSEventsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.eventManager = [UTCSEventsManager new];
        
        self.backgroundHeaderBlurTableView = [[UTCSBackgroundHeaderBlurTableView alloc]initWithFrame:self.view.bounds];
        self.backgroundHeaderBlurTableView.backgroundImage = [[UIImage imageNamed:@"menuBackground"]tintedImageWithColor:[UIColor utcsImageTintColor] blendingMode:kCGBlendModeOverlay];
        self.backgroundHeaderBlurTableView.backgroundBlurredImage = [[UIImage imageNamed:@"menuBackground-blurred"]tintedImageWithColor:[UIColor utcsImageTintColor] blendingMode:kCGBlendModeOverlay];
        self.backgroundHeaderBlurTableView.tableView.delegate = self;
        self.backgroundHeaderBlurTableView.tableView.dataSource = self.eventManager;
        [self.view addSubview:self.backgroundHeaderBlurTableView];
        
        self.utcsEventsShimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
        self.utcsEventsShimmeringView.center = CGPointMake(self.view.center.x, 0.7 * self.view.center.y);
        self.utcsEventsShimmeringView.contentView = ({
            UILabel *label = [[UILabel alloc]initWithFrame:self.utcsEventsShimmeringView.bounds];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:48];
            label.text = @"UTCS Events";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label;
        });
        [self.backgroundHeaderBlurTableView.header addSubview:self.utcsEventsShimmeringView];
        
        self.updatedLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, self.backgroundHeaderBlurTableView.header.height - 64.0,
                                                                      self.backgroundHeaderBlurTableView.header.width - 16, 18)];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label;
        });
        self.updatedLabel.alpha = 0.0;
        [self.backgroundHeaderBlurTableView.header addSubview:self.updatedLabel];
        
        // Menu Button
        self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
        [self.view addSubview:self.menuButton];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(!self.hasAppeared) {
        self.utcsEventsShimmeringView.shimmering = YES;
        [self.eventManager updateEventsWithCompletion:^{
            self.utcsEventsShimmeringView.shimmering = NO;
            if([self.eventManager.events count] > 0) {
                self.hasAppeared = YES;
                self.updatedLabel.text = [NSString stringWithFormat:@"Updated %@",
                                          [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                         dateStyle:NSDateFormatterLongStyle
                                                                         timeStyle:NSDateFormatterMediumStyle]];
                [self.backgroundHeaderBlurTableView.tableView reloadData];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                self.descriptionLabel.alpha = 1.0;
                self.updatedLabel.alpha = 1.0;
            }];
            
        }];
    }
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (3.0 * [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize +
            [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1].pointSize) + 32.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (3.0 * [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize) + [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1].pointSize;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    UTCSEvent *event = self.eventManager.events[indexPath.row];
    self.eventDetailViewController = [UTCSEventDetailViewController new];
    self.eventDetailViewController.event = event;
    [self.navigationController pushViewController:self.eventDetailViewController animated:YES];
}


@end
