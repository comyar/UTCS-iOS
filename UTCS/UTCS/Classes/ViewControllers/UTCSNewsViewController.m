//
//  UTCSNewsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsViewController.h"
#import "UTCSVerticalMenuViewController.h"
#import "UTCSNewsDetailViewController.h"
#import "UTCSBackgroundHeaderBlurTableView.h"
#import "UIImage+CZTinting.h"

#import "FBShimmeringView.h"
#import "UTCSNewsStoryManager.h"
#import "UTCSNewsStory.h"

#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"
#import "UIImage+ImageEffects.h"
#import "UTCSMenuButton.h"

// Constants

const NSTimeInterval kMinTimeIntervalBetweenUpdates = 3600;


#pragma mark - UTCSNewsViewController Class Extension

@interface UTCSNewsViewController ()

//
@property (assign, nonatomic) BOOL hasAppeared;

//
@property (nonatomic) FBShimmeringView                      *utcsNewsShimmeringView;

//
@property (nonatomic) UILabel                               *utcsDescriptionLabel;

//
@property (strong, nonatomic) UIButton                      *menuButton;

//
@property (nonatomic) NSArray                               *newsStories;

//
@property (nonatomic) UTCSNewsStoryManager               *dataSource;

//
@property (nonatomic) UILabel                               *updatedLabel;

@property (nonatomic) UTCSNewsDetailViewController          *newsDetailViewController;

@property (nonatomic) UTCSBackgroundHeaderBlurTableView     *backgroundHeaderBlurTableView;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataSource = [UTCSNewsStoryManager new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundHeaderBlurTableView = [[UTCSBackgroundHeaderBlurTableView alloc]initWithFrame:self.view.bounds];
    self.backgroundHeaderBlurTableView.backgroundImage = [[UIImage imageNamed:@"newsBackground"]tintedImageWithColor:[UIColor utcsImageTintColor] blendingMode:kCGBlendModeOverlay];
    self.backgroundHeaderBlurTableView.backgroundBlurredImage = [[UIImage imageNamed:@"newsBackground-blurred"]tintedImageWithColor:[UIColor utcsImageTintColor] blendingMode:kCGBlendModeOverlay];
    self.backgroundHeaderBlurTableView.tableView.delegate = self;
    self.backgroundHeaderBlurTableView.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.backgroundHeaderBlurTableView];
    
    self.utcsNewsShimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    self.utcsNewsShimmeringView.center = CGPointMake(self.view.center.x, 0.7 * self.view.center.y);
    self.utcsNewsShimmeringView.contentView = ({
        UILabel *label = [[UILabel alloc]initWithFrame:self.utcsNewsShimmeringView.bounds];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
        label.text = @"UTCS News";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label;
    });
    [self.backgroundHeaderBlurTableView.header addSubview:self.utcsNewsShimmeringView];
    

    self.utcsDescriptionLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        label.center = CGPointMake(self.view.center.x, 0.9 * self.view.center.y);
        label.text = @"What starts here changes the world.";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        label;
    });
    self.utcsDescriptionLabel.alpha = 0.0;
    [self.backgroundHeaderBlurTableView.header addSubview:self.utcsDescriptionLabel];

    self.updatedLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, self.backgroundHeaderBlurTableView.header.height - 96.0,
                                                                  self.backgroundHeaderBlurTableView.header.width - 16, 18)];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label;
    });
    self.updatedLabel.alpha = 0.0;
    [self.backgroundHeaderBlurTableView.header addSubview:self.updatedLabel];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(8, 8, 56, 32)];
    [self.view addSubview:self.menuButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(!self.hasAppeared) {
        self.backgroundHeaderBlurTableView.tableView.scrollEnabled = NO;
        self.utcsNewsShimmeringView.shimmering = YES;
        [self.dataSource updateNewsStories:^{
            self.utcsNewsShimmeringView.shimmering = NO;
            if([self.dataSource.newsStories count] > 0) {
                self.hasAppeared = YES;
                self.updatedLabel.text = [NSString stringWithFormat:@"Updated %@",
                                          [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                         dateStyle:NSDateFormatterLongStyle
                                                                         timeStyle:NSDateFormatterMediumStyle]];
            } else {
                self.updatedLabel.text = @"No news stories available.";
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                self.utcsDescriptionLabel.alpha = 1.0;
                self.updatedLabel.alpha = 1.0;
            }];
            self.backgroundHeaderBlurTableView.tableView.scrollEnabled = YES;
            [self.backgroundHeaderBlurTableView.tableView reloadData];
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSNewsStory *newsStory = self.dataSource.newsStories[indexPath.row];
    CGRect rect = [newsStory.title boundingRectWithSize:CGSizeMake(self.backgroundHeaderBlurTableView.tableView.width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                                context:nil];
    return ceilf(rect.size.height) + 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO animated:NO];
    [cell setSelected:NO animated:NO];
    UTCSNewsStory *newsStory = self.dataSource.newsStories[indexPath.row];
    self.newsDetailViewController = [UTCSNewsDetailViewController new];
    
    self.newsDetailViewController.newsStory = newsStory;
    [self.navigationController pushViewController:self.newsDetailViewController animated:YES];
}

@end
