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
#import "UTCSNewsHeaderView.h"
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

// -----
// @name Views
// -----

// Button used to show/hide the menu view
@property (nonatomic) UIButton                              *menuButton;

//
@property (nonatomic) UTCSNewsHeaderView                    *headerView;

// View used to display the table of news stories as well as a blurring header
@property (nonatomic) UTCSBackgroundHeaderBlurTableView     *backgroundHeaderBlurTableView;


// -----
// @name View Controllers
// -----

// Manager used to update the news stories and is the data source for the table view
@property (nonatomic) UTCSNewsStoryDataSource               *newsStoryDataSource;

// View controller used to display a specific news story
@property (nonatomic) UTCSNewsDetailViewController          *newsDetailViewController;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"News";
        
        self.newsStoryDataSource = [UTCSNewsStoryDataSource new];
        
        // Background header blur table view
        self.backgroundHeaderBlurTableView = ({
            UTCSBackgroundHeaderBlurTableView *view = [[UTCSBackgroundHeaderBlurTableView alloc]initWithFrame:self.view.bounds];
            view.tableView.delegate     = self;
            view.tableView.dataSource   = self.newsStoryDataSource;
            view.backgroundImage        = [[UIImage imageNamed:backgroundImageName]tintedImageWithColor:[UIColor utcsImageTintColor]
                                                                                           blendingMode:kCGBlendModeOverlay];
            view.backgroundBlurredImage = [[UIImage imageNamed:backgroundBlurredImageName]tintedImageWithColor:[UIColor utcsImageTintColor]
                                                                                                  blendingMode:kCGBlendModeOverlay];
            [self.view addSubview:view];
            view;
        });
        
        self.headerView = ({
            UTCSNewsHeaderView *view = [[UTCSNewsHeaderView alloc]initWithFrame:self.backgroundHeaderBlurTableView.header.bounds];
            [self.backgroundHeaderBlurTableView.header addSubview:view];
            view;
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
}

#pragma mark Update data source

- (void)update
{
    [UIView animateWithDuration:0.3 animations:^{
        self.headerView.downArrowImageView.alpha = 0.0;
    }];
    
    self.headerView.shimmeringView.shimmering = YES;
    [self.headerView.activityIndicatorView startAnimating];
    
    // Update news stories
    [self.newsStoryDataSource updateNewsStoriesWithCompletion:^{
        [self.headerView.activityIndicatorView stopAnimating];
        self.headerView.shimmeringView.shimmering = NO;
        if([self.newsStoryDataSource.newsStories count] > 0) {
            self.headerView.updatedLabel.text = [NSString stringWithFormat:@"Updated %@",
                                      [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                     dateStyle:NSDateFormatterLongStyle
                                                                     timeStyle:NSDateFormatterMediumStyle]];
        } else {
            self.headerView.updatedLabel.text = @"No news stories available.";
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.headerView.updatedLabel.alpha         = 1.0;
            self.headerView.subtitleLabel.alpha    = 1.0;
            self.headerView.downArrowImageView.alpha   = ([self.newsStoryDataSource.newsStories count])? 1.0 : 0.0;
        }];
        
        [self.backgroundHeaderBlurTableView.tableView reloadData];
    }];
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSNewsStory *newsStory = self.newsStoryDataSource.newsStories[indexPath.row];
    
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
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UTCSNewsStory *newsStory = self.newsStoryDataSource.newsStories[indexPath.row];
    
    if(!self.newsDetailViewController) {
        self.newsDetailViewController = [UTCSNewsDetailViewController new];
    }
    self.newsDetailViewController.newsStory = newsStory;
    
    [self.navigationController pushViewController:self.newsDetailViewController animated:YES];
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self bounceCell:cell down:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.alpha = 1.0;
    cell.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
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
