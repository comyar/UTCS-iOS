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

#import "FBShimmeringView.h"
#import "UTCSNewsStoryDataSource.h"
#import "UTCSNewsStory.h"

#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"
#import "UIImage+ImageEffects.h"

// Constants

const NSTimeInterval kMinTimeIntervalBetweenUpdates = 3600;


#pragma mark - UTCSNewsViewController Class Extension

@interface UTCSNewsViewController ()

//
@property (assign, nonatomic) BOOL hasAppeared;

//
@property (nonatomic) UIImageView                           *backgroundImageView;

//
@property (nonatomic) UIImageView                           *blurredBackgroundImageView;

//
@property (nonatomic) FBShimmeringView                      *utcsNewsShimmeringView;

//
@property (nonatomic) UILabel                               *utcsDescriptionLabel;

//
@property (strong, nonatomic) UIButton                      *menuButton;

//
@property (strong, nonatomic) UITableView                   *newsTableView;

//
@property (nonatomic) UIView                                *newsTableViewHeaderContainer;

//
@property (nonatomic) NSArray                               *newsStories;

//
@property (nonatomic) UTCSNewsStoryDataSource               *dataSource;

//
@property (nonatomic) UILabel                               *updatedLabel;

@property (nonatomic) UIImageView                           *downArrowImageView;

@property (nonatomic) UIView                                *topSeparator;

@property (nonatomic) UTCSNewsDetailViewController          *newsDetailViewController;

@end


#pragma mark - UTCSNewsViewController Implementation

@implementation UTCSNewsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataSource = [UTCSNewsStoryDataSource new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newsBackground"]];
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newsBackground-blurred"]];
    self.blurredBackgroundImageView.alpha = 0.0;
    [self.view addSubview:self.blurredBackgroundImageView];
    
    self.newsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)
                                                     style:UITableViewStylePlain];
    [self.newsTableView registerNib:[UINib nibWithNibName:@"UTCSNewsTableViewCell" bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:@"UTCSNewsTableViewCell"];
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsTableView.rowHeight = 128;
    self.newsTableView.backgroundColor = [UIColor clearColor];
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self.dataSource;
    self.newsTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    self.newsTableView.scrollsToTop = YES;
    [self.view addSubview:self.newsTableView];
    
    self.newsTableViewHeaderContainer = [[UIView alloc]initWithFrame:self.newsTableView.bounds];
    self.newsTableView.tableHeaderView = self.newsTableViewHeaderContainer;
    
    self.utcsNewsShimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    self.utcsNewsShimmeringView.center = CGPointMake(self.view.center.x, 0.7 * self.view.center.y);
    self.utcsNewsShimmeringView.contentView = ({
        UILabel *label = [[UILabel alloc]initWithFrame:self.utcsNewsShimmeringView.bounds];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
        label.text = @"UTCS News";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.shadowOffset = CGSizeMake(0, 2);
        label;
    });
    [self.newsTableViewHeaderContainer addSubview:self.utcsNewsShimmeringView];
    
    self.utcsDescriptionLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        label.center = CGPointMake(self.view.center.x, 0.9 * self.view.center.y);
        label.text = @"What starts here changes the world.";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        label;
    });
    [self.newsTableViewHeaderContainer addSubview:self.utcsDescriptionLabel];
    
    
    self.downArrowImageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"arrowDown"]
                                                                 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    self.downArrowImageView.tintColor = [UIColor whiteColor];
    self.downArrowImageView.alpha = 0.0;
    self.downArrowImageView.center = CGPointMake(self.view.center.x, 1.25 * self.view.center.y);
    [self.newsTableViewHeaderContainer addSubview:self.downArrowImageView];
    
    
    self.updatedLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, self.newsTableView.height - 32, self.newsTableView.width - 16, 18)];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label;
    });
    [self.newsTableViewHeaderContainer addSubview:self.updatedLabel];
    
    // Menu Button
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.tag = INT32_MIN;
    self.menuButton.frame = CGRectMake(8, 8, 64, 32);
    self.menuButton.contentEdgeInsets = UIEdgeInsetsMake(16, 0, 16, 0);
    self.menuButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    [self.menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    [self.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton addTarget:self action:@selector(didTouchDownInsideButton:) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.menuButton];
    
    self.topSeparator = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 1)];
    self.topSeparator.backgroundColor = [UIColor whiteColor];
    self.topSeparator.alpha = 0.0;
    [self.view addSubview:self.topSeparator];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.hasAppeared) {
        self.hasAppeared = YES;
        self.newsTableView.scrollEnabled = NO;
        self.utcsNewsShimmeringView.shimmering = YES;
        [self.dataSource updateNewsStories:^{
            self.utcsNewsShimmeringView.shimmering = NO;
            if([self.dataSource.newsStories count] > 0) {
                self.updatedLabel.text = [NSString stringWithFormat:@"Updated %@",
                                          [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                         dateStyle:NSDateFormatterLongStyle
                                                                         timeStyle:NSDateFormatterMediumStyle]];
                [UIView animateWithDuration:0.25 animations:^{
                    self.downArrowImageView.alpha = 1.0;
                }];
            } else {
                self.updatedLabel.text = @"No news stories available.";
                [UIView animateWithDuration:0.25 animations:^{
                    self.downArrowImageView.alpha = 0.0;
                }];
            }
            self.newsTableView.scrollEnabled = YES;
            [self.newsTableView reloadData];
        }];
    }
}

- (void)didTouchDownInsideButton:(UIButton *)button
{
    if(button == self.menuButton) {
        button.alpha = 0.5;
    }
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.menuButton) {
        button.alpha = 1.0;
        button.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:UTCSVerticalMenuDisplayNotification
                                                                                            object:self]];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark UTCSVerticalMenuViewControllerDelegate Methods

- (BOOL)shouldRecognizeVerticalMenuViewControllerPanGesture
{
    return (self.newsTableView.contentOffset.y < 8);
}

- (void)verticalMenuViewController:(UTCSVerticalMenuViewController *)verticalMenuViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    self.newsTableView.userInteractionEnabled = NO;
    self.menuButton.userInteractionEnabled = NO;
}

- (void)verticalMenuViewController:(UTCSVerticalMenuViewController *)verticalMenuViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    self.newsTableView.userInteractionEnabled = YES;
    self.menuButton.userInteractionEnabled = YES;
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.alpha = 0.5;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.alpha = 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSNewsStory *newsStory = self.dataSource.newsStories[indexPath.row];
    self.newsDetailViewController = [UTCSNewsDetailViewController new];
    self.newsDetailViewController.newsStory = newsStory;
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.blurredBackgroundImageView.alpha = MIN(1.0, 4.0 * MAX(scrollView.contentOffset.y / self.view.height, 0.0));
    self.topSeparator.alpha = MIN(1.0, MAX(scrollView.contentOffset.y / self.view.height, 0.0));
}

@end
