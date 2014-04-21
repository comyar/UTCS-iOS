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
#import "UTCSNewsHeaderView.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"
#import "UIImage+ImageEffects.h"

// Models
#import "UTCSNewsArticle.h"
#import "UTCSNewsArticleDataSource.h"


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

// Header view of the table view
@property (nonatomic) UTCSNewsHeaderView                *activityHeaderView;

// Data source used for the news articles
@property (nonatomic) UTCSNewsArticleDataSource         *newsArticleDataSource;

// View controller used to display a specific news story
@property (nonatomic) UTCSNewsDetailViewController      *newsDetailViewController;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.newsArticleDataSource = [UTCSNewsArticleDataSource new];
        
        self.backgroundImageView.image = [UIImage imageNamed:backgroundImageName];
        self.backgroundBlurredImageView.image = [UIImage imageNamed:backgroundBlurredImageName];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.activityHeaderView = [[UTCSNewsHeaderView alloc]initWithFrame:self.tableView.bounds];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

#pragma mark Updating

- (void)update
{
    [self.activityHeaderView showActivityAnimation:YES];
    
    // Update news stories
    [self.newsArticleDataSource updateNewsArticlesWithCompletion:^ (NSDate *updated) {
        
        [self.activityHeaderView showActivityAnimation:NO];
        
        if([self.newsArticleDataSource.newsArticles count] > 0) {
            NSString *updateString = [NSDateFormatter localizedStringFromDate:updated
                                                                    dateStyle:NSDateFormatterLongStyle
                                                                    timeStyle:NSDateFormatterMediumStyle];
            self.activityHeaderView.updatedLabel.text = [NSString stringWithFormat:@"Updated %@", updateString];
        } else {
            self.activityHeaderView.updatedLabel.text = @"No news stories available.";
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSNewsArticle *newsStory = self.newsArticleDataSource.newsArticles[indexPath.row];
    
    // Estimate height of a news story title
    CGRect rect = [newsStory.title boundingRectWithSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)
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
    
    UTCSNewsArticle *newsStory = self.newsArticleDataSource.newsArticles[indexPath.row];
    
    if(!self.newsDetailViewController) {
        self.newsDetailViewController = [UTCSNewsDetailViewController new];
    }
    self.newsDetailViewController.newsArticle = newsStory;
    
    [self.navigationController pushViewController:self.newsDetailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setHighlighted:NO animated:NO];
    cell.alpha = 0.8;
    cell.transform = CGAffineTransformMakeScale(0.98, 0.98);
    [UIView animateWithDuration:animationDuration animations:^{
        cell.alpha = 1.0;
        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

@end
