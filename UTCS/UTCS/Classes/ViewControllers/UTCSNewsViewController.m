//
//  UTCSNewsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

// View controllers
#import "UTCSNewsViewController.h"
#import "UTCSNewsDetailViewController.h"

// Views
#import "UTCSMenuButton.h"
#import "FBShimmeringView.h"
#import "UTCSBackgroundHeaderBlurTableView.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"
#import "UIImage+ImageEffects.h"

// Models
#import "UTCSNewsStory.h"
#import "UTCSNewsStoryManager.h"


#pragma mark - Constants

/**
 The minimum number of seconds between updates
 */
//static const NSTimeInterval kMinTimeIntervalBetweenUpdates = 3600;

/**
 Font size of the shimmering view
 */
static const CGFloat shimmeringViewFontSize         = 50.0;

/**
 Font size of the subtitle label
 */
static const CGFloat subtitleLabelFontSize          = 17.0;

/**
 Font size of the updated label
 */
static const CGFloat updatedLabelFontSize           = 14.0;

/**
 Estimated height of table view cell
 */
static const CGFloat estiabledCellHeight            = 128.0;

/**
 Estimated height of a table view cell's detail label
 */
static const CGFloat estimatedCellDetailLabelHeight = 80.0;

/**
 Name of the background image
 */
static NSString * const backgroundImageName         = @"newsBackground";

/**
 Name of the blurred background image
 */
static NSString * const backgroundBlurredImageName  = @"newsBackground-blurred";


#pragma mark - UTCSNewsViewController Class Extension

@interface UTCSNewsViewController ()

/**
 Shimmering view used to indicate loading of news articles
 */
@property (nonatomic) FBShimmeringView                      *utcsNewsShimmeringView;

/**
 Label used to display a subtitle beneath the shimmering view
 */
@property (nonatomic) UILabel                               *utcsSubtitleLabel;

/**
 Button used to show/hide the menu view
 */
@property (nonatomic) UIButton                              *menuButton;

/**
 Manager used to update the news stories and is the data source for the table view
 */
@property (nonatomic) UTCSNewsStoryManager                  *newsStoryManager;

/**
 Label used to display the time the news stories were updated
 */
@property (nonatomic) UILabel                               *updatedLabel;

/**
 View controller used to display a specific news story
 */
@property (nonatomic) UTCSNewsDetailViewController          *newsDetailViewController;

/**
 View used to display the table of news stories as well as a blurring header
 */
@property (nonatomic) UTCSBackgroundHeaderBlurTableView     *backgroundHeaderBlurTableView;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.newsStoryManager = [UTCSNewsStoryManager new];
        self.newsDetailViewController = [UTCSNewsDetailViewController new];
        
        // Background header blur table view
        self.backgroundHeaderBlurTableView = ({
            UTCSBackgroundHeaderBlurTableView *view = [[UTCSBackgroundHeaderBlurTableView alloc]initWithFrame:self.view.bounds];
            view.tableView.delegate = self;
            view.tableView.dataSource = self.newsStoryManager;
            view.backgroundImage        = [[UIImage imageNamed:backgroundImageName]tintedImageWithColor:[UIColor utcsImageTintColor]
                                                                                           blendingMode:kCGBlendModeOverlay];
            view.backgroundBlurredImage = [[UIImage imageNamed:backgroundBlurredImageName]tintedImageWithColor:[UIColor utcsImageTintColor]
                                                                                                  blendingMode:kCGBlendModeOverlay];
            view;
        });
        [self.view addSubview:self.backgroundHeaderBlurTableView];
        
        // Shimmering view
        self.utcsNewsShimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, shimmeringViewFontSize)];
        self.utcsNewsShimmeringView.center = CGPointMake(self.view.center.x, 0.7 * self.view.center.y);
        self.utcsNewsShimmeringView.contentView = ({
            UILabel *label      = [[UILabel alloc]initWithFrame:self.utcsNewsShimmeringView.bounds];
            label.font          = [UIFont fontWithName:@"HelveticaNeue-Bold" size:shimmeringViewFontSize];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor     = [UIColor whiteColor];
            label.text          = @"UTCS News";
            label;
        });
        [self.backgroundHeaderBlurTableView.header addSubview:self.utcsNewsShimmeringView];
        
        // Subtitle label
        self.utcsSubtitleLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 1.5 * subtitleLabelFontSize)];
            label.font          = [UIFont fontWithName:@"HelveticaNeue" size:subtitleLabelFontSize];
            label.center        = CGPointMake(self.view.center.x, 0.85 * self.view.center.y);
            label.text          = @"What Starts Here Changes the World";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor     = [UIColor colorWithWhite:1.0 alpha:0.8];
            label.alpha         = 0.0;
            label;
        });
        [self.backgroundHeaderBlurTableView.header addSubview:self.utcsSubtitleLabel];
        
        // Updated label
        self.updatedLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8.0,self.backgroundHeaderBlurTableView.header.height - self.backgroundHeaderBlurTableView.navigationBarHeight - updatedLabelFontSize - 8.0, self.backgroundHeaderBlurTableView.width - 16.0, 1.5 * updatedLabelFontSize)];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:updatedLabelFontSize];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.alpha = 0.0;
            label;
        });
        [self.backgroundHeaderBlurTableView.header addSubview:self.updatedLabel];
        
        // Menu Button
        self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2.0, 8.0, 56.0, 32.0)];
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if([self.newsStoryManager.newsStories count]) {
        return;
    }
    
    self.utcsNewsShimmeringView.shimmering = YES;
    self.backgroundHeaderBlurTableView.tableView.scrollEnabled = NO;
    
    // Update news stories if manager has no stories
    [self.newsStoryManager updateNewsStories:^{
        self.utcsNewsShimmeringView.shimmering = NO;
        if([self.newsStoryManager.newsStories count] > 0) {
            self.updatedLabel.text = [NSString stringWithFormat:@"Updated %@",
                                      [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                     dateStyle:NSDateFormatterLongStyle
                                                                     timeStyle:NSDateFormatterMediumStyle]];
        } else {
            self.updatedLabel.text = @"No news stories available.";
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.utcsSubtitleLabel.alpha = 1.0;
            self.updatedLabel.alpha = 1.0;
        }];
        
        self.backgroundHeaderBlurTableView.tableView.scrollEnabled = YES;
        [self.backgroundHeaderBlurTableView.tableView reloadData];
    }];
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSNewsStory *newsStory = self.newsStoryManager.newsStories[indexPath.row];
    
    // Estimate height of a news story title
    CGRect rect = [newsStory.title boundingRectWithSize:CGSizeMake(self.backgroundHeaderBlurTableView.tableView.width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                                context:nil];
    return MIN(ceilf(rect.size.height), estimatedCellDetailLabelHeight) + estimatedCellDetailLabelHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return estiabledCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    UTCSNewsStory *newsStory = self.newsStoryManager.newsStories[indexPath.row];
    self.newsDetailViewController.newsStory = newsStory;
    
    [self.navigationController pushViewController:self.newsDetailViewController animated:YES];
}

@end
