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
#import "UTCSNewsDataSource.h"


#pragma mark - Constants

static NSString * const serviceName = @"news";

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
//@property (nonatomic) UTCSNewsHeaderView                *activityHeaderView;

// View controller used to display a specific news story
@property (nonatomic) UTCSNewsDetailViewController      *newsDetailViewController;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if(self = [super initWithStyle:style]) {
        self.dataSource             = [[UTCSNewsDataSource alloc]initWithService:serviceName];
        
        self.tableView.dataSource   = (UTCSNewsDataSource *)self.dataSource;
        self.tableView.delegate     = self;
        
        self.backgroundImageView.image          = [UIImage imageNamed:backgroundImageName];
        self.backgroundBlurredImageView.image   = [UIImage imageNamed:backgroundBlurredImageName];
        self.activeHeaderView = [[UTCSNewsHeaderView alloc]initWithFrame:self.tableView.bounds];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

#pragma mark Updating

- (void)update
{
    [self.activeHeaderView showActiveAnimation:YES];
    
    [self updateWithArgument:nil completion:^(BOOL success) {
        
        [self.activeHeaderView showActiveAnimation:NO];
        
        if([self.dataSource.data count] > 0) {
            NSString *updateString = [NSDateFormatter localizedStringFromDate:self.dataSource.updated
                                                                    dateStyle:NSDateFormatterLongStyle
                                                                    timeStyle:NSDateFormatterMediumStyle];
            self.activeHeaderView.updatedLabel.text = [NSString stringWithFormat:@"Updated %@", updateString];
        } else {
            
            if (!success) {
                // Show frowny face, error message
            }
            
            self.activeHeaderView.updatedLabel.text = @"No News Articles Available";
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSNewsArticle *article = self.dataSource.data[indexPath.row];
    
    // Estimate height of a news story title
    CGRect rect = [article.title boundingRectWithSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                                context:nil];
    
    return MIN(ceilf(rect.size.height), estimatedCellDetailLabelHeight) + estimatedCellDetailLabelHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return estimatedCellHeight;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UTCSNewsArticle *article = self.dataSource.data[indexPath.row];
    
    if(!self.newsDetailViewController) {
        self.newsDetailViewController = [UTCSNewsDetailViewController new];
    }
    self.newsDetailViewController.newsArticle = article;
    
    [self.navigationController pushViewController:self.newsDetailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.alpha = 1.0;
//    cell.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

@end
