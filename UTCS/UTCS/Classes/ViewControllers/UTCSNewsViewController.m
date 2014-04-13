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
#import "UTCSNewsStoryDataSource.h"


#pragma mark - Constants

// Font size of the shimmering view
static const CGFloat shimmeringViewFontSize         = 50.0;

// Font size of the subtitle label
static const CGFloat subtitleLabelFontSize          = 17.0;

// Font size of the updated label
static const CGFloat updatedLabelFontSize           = 14.0;

// Estimated height of table view cell
static const CGFloat estimatedCellHeight            = 140.0;

// Estimated height of a table view cell's detail label
static const CGFloat estimatedCellDetailLabelHeight = 85.0;

// Duration of animations performed by this view controller
static const CGFloat animationDuration              = 0.3;

// Name of the background image
static NSString * const backgroundImageName         = @"newsBackground";

// Name of the blurred background image
static NSString * const backgroundBlurredImageName  = @"newsBackground-blurred";


#pragma mark - UTCSNewsViewController Class Extension

@interface UTCSNewsViewController ()

// Button used to show/hide the menu view
@property (nonatomic) UIButton                              *menuButton;

// Label used to display the time the news stories were updated
@property (nonatomic) UILabel                               *updatedLabel;

// Label used to display a subtitle beneath the shimmering view
@property (nonatomic) UILabel                               *utcsSubtitleLabel;

// Image view used to render the down arrow
@property (nonatomic) UIImageView                           *downArrowImageView;

// Activity indicator used to indicate the news stories are updating
@property (nonatomic) UIActivityIndicatorView               *activityIndicatorView;

// Shimmering view used to indicate loading of news articles
@property (nonatomic) FBShimmeringView                      *utcsNewsShimmeringView;

// Manager used to update the news stories and is the data source for the table view
@property (nonatomic) UTCSNewsStoryDataSource                  *newsStoryManager;

// View controller used to display a specific news story
@property (nonatomic) UTCSNewsDetailViewController          *newsDetailViewController;

// View used to display the table of news stories as well as a blurring header
@property (nonatomic) UTCSBackgroundHeaderBlurTableView     *backgroundHeaderBlurTableView;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"News";
        
        self.newsStoryManager = [UTCSNewsStoryDataSource new];
        
        // Background header blur table view
        self.backgroundHeaderBlurTableView = ({
            UTCSBackgroundHeaderBlurTableView *view = [[UTCSBackgroundHeaderBlurTableView alloc]initWithFrame:self.view.bounds];
            view.tableView.delegate     = self;
            view.tableView.dataSource   = self.newsStoryManager;
            view.backgroundImage        = [[UIImage imageNamed:backgroundImageName]tintedImageWithColor:[UIColor utcsImageTintColor]
                                                                                           blendingMode:kCGBlendModeOverlay];
            view.backgroundBlurredImage = [[UIImage imageNamed:backgroundBlurredImageName]tintedImageWithColor:[UIColor utcsImageTintColor]
                                                                                                  blendingMode:kCGBlendModeOverlay];
            [self.view addSubview:view];
            view;
        });
        
        // Shimmering view
        self.utcsNewsShimmeringView = ({
            FBShimmeringView *view = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, shimmeringViewFontSize)];
            view.center = CGPointMake(self.view.center.x, 0.7 * self.view.center.y);
            
            view.contentView = ({
                UILabel *label      = [[UILabel alloc]initWithFrame:self.utcsNewsShimmeringView.bounds];
                label.font          = [UIFont fontWithName:@"HelveticaNeue-Bold" size:shimmeringViewFontSize];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor     = [UIColor whiteColor];
                label.text          = @"UTCS News";
                label;
            });
            
            [self.backgroundHeaderBlurTableView.header addSubview:view];
            view;
        });
        
        // Subtitle label
        self.utcsSubtitleLabel = ({
            UILabel *label      = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 1.5 * subtitleLabelFontSize)];
            label.font          = [UIFont fontWithName:@"HelveticaNeue" size:subtitleLabelFontSize];
            label.center        = CGPointMake(self.view.center.x, 0.85 * self.view.center.y);
            label.text          = @"What Starts Here Changes the World";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor     = [UIColor colorWithWhite:1.0 alpha:0.8];
            label.alpha         = 0.0;
            [self.backgroundHeaderBlurTableView.header addSubview:label];
            label;
        });
        
        // Down arrow image view
        self.downArrowImageView = ({
            UIImage *image = [[UIImage imageNamed:@"downArrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.frame = CGRectMake(0.0, 0.0, 32, 16);
            imageView.tintColor = [UIColor whiteColor];
            imageView.alpha = 0.0;
            [self.backgroundHeaderBlurTableView.header addSubview:imageView];
            imageView;
        });
        
        // Activity indicator view
        self.activityIndicatorView = ({
            UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            view.center = CGPointMake(self.view.center.x, 1.5 * self.view.center.y);
            [self.backgroundHeaderBlurTableView.header addSubview:view];
            view;
        });
        
        // Updated label
        self.updatedLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(13.0, self.backgroundHeaderBlurTableView.header.height - self.backgroundHeaderBlurTableView.navigationBarHeight - updatedLabelFontSize - 8.0, self.backgroundHeaderBlurTableView.width - 16.0, 1.5 * updatedLabelFontSize)];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:updatedLabelFontSize];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.alpha = 0.0;
            [self.backgroundHeaderBlurTableView.header addSubview:label];
            label;
        });
        
        // Menu Button
        self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2.0, 8.0, 56.0, 32.0)];
        [self.view addSubview:self.menuButton];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.backgroundHeaderBlurTableView.frame    = self.view.bounds;
    
    self.utcsNewsShimmeringView.frame           = CGRectMake(0.0, 0.0, self.view.width, shimmeringViewFontSize);
    self.utcsNewsShimmeringView.center          = CGPointMake(self.view.center.x, 0.7 * self.view.center.y);
    
    self.utcsSubtitleLabel.frame                = CGRectMake(0, 0, self.view.width, 1.5 * subtitleLabelFontSize);
    self.utcsSubtitleLabel.center               = CGPointMake(self.view.center.x, 0.85 * self.view.center.y);
    
    self.downArrowImageView.center              = CGPointMake(self.view.center.x, 1.33 * self.view.center.y);
    self.activityIndicatorView.center           = CGPointMake(self.view.center.x, 1.33 * self.view.center.y);
    
    self.updatedLabel.frame = CGRectMake(13.0, self.backgroundHeaderBlurTableView.header.height - self.backgroundHeaderBlurTableView.navigationBarHeight - updatedLabelFontSize - 8.0, self.backgroundHeaderBlurTableView.width - 16.0, 1.5 * updatedLabelFontSize);
}

#pragma mark Update data source

- (void)update
{
    [UIView animateWithDuration:0.3 animations:^{
        self.downArrowImageView.alpha = 0.0;
    }];
    
    self.utcsNewsShimmeringView.shimmering = YES;
    [self.activityIndicatorView startAnimating];
    
    // Update news stories
    [self.newsStoryManager updateNewsStoriesWithCompletion:^{
        [self.activityIndicatorView stopAnimating];
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
            self.updatedLabel.alpha         = 1.0;
            self.utcsSubtitleLabel.alpha    = 1.0;
            self.downArrowImageView.alpha   = ([self.newsStoryManager.newsStories count])? 1.0 : 0.0;
        }];
        
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
    return estimatedCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UTCSNewsStory *newsStory = self.newsStoryManager.newsStories[indexPath.row];
    
    if(!self.newsDetailViewController) {
        self.newsDetailViewController = [UTCSNewsDetailViewController new];
    }
    self.newsDetailViewController.newsStory = newsStory;
    
    [self.navigationController pushViewController:self.newsDetailViewController animated:YES];
    cell.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self bounceCell:cell down:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self bounceCell:cell down:NO];
}

- (void)bounceCell:(UITableViewCell *)cell down:(BOOL)down
{
    [UIView animateWithDuration:animationDuration/3.0 animations:^{
        cell.contentView.transform = (down)? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration/3.0 animations:^{
            cell.contentView.transform = (down)? CGAffineTransformMakeScale(0.95, 0.95) : CGAffineTransformMakeScale(0.975, 0.975);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration/3.0 animations:^{
                cell.contentView.transform = (down)? CGAffineTransformMakeScale(0.925, 0.925) : CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        cell.contentView.alpha = (down)? 0.5 : 1.0;
    }];
}

@end
