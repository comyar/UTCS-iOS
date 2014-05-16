//
//  UTCSEventsStarListViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSEvent.h"
#import "UIButton+UTCSButton.h"
#import "UTCSStarredEventsManager.h"
#import "UTCSStarredEventsDataSource.h"
#import "UTCSStarredEventsViewController.h"


#pragma mark - UTCSStarredEventsViewController Class Extension

@interface UTCSStarredEventsViewController ()

// Done button
@property (nonatomic) UIButton                      *doneButton;

// Data source of the starred events table view
@property (nonatomic) UTCSStarredEventsDataSource   *dataSource;

// Label visible when there are no starred events
@property (nonatomic) UILabel                       *descriptionLabel;

@end


#pragma mark - UTCSStarredEventsViewController Implementation

@implementation UTCSStarredEventsViewController

#pragma mark Creating a Starred Events View Controller

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.backgroundImageView.alpha = 0.0;
        self.dataSource = [UTCSStarredEventsDataSource new];
        self.tableView.dataSource = self.dataSource;
        self.tableView.allowsSelectionDuringEditing = YES;
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuButton.hidden = YES;
    
    self.tableView.editing = YES;
    
    self.doneButton = ({
        UIButton *button = [UIButton bouncyButton];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0.0, 0.0, 60.0, 28.0);
        button.center = CGPointMake(self.view.width - 41, 22);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [button setTitle:@"Done" forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        button;
    });
    
    [self.view addSubview:({
        UIView *overlay = [[UIView alloc]initWithFrame:self.view.bounds];
        overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        overlay;
    })];
    
    self.descriptionLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16.0, 0.0, self.view.width - 32.0, 128.0)];
        label.center = self.view.center;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 0;
        label.text = @"No Starred Events! Starred events will appear in this menu and can be configured in Settings to send you notifications before they begin.";
        label.alpha = 0.0;
        label;
    });
    
    [self.view addSubview:self.descriptionLabel];
    
    [self.view addSubview:self.doneButton];
    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.doneButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.backgroundImageView.alpha = 1.0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.backgroundImageView.alpha = 0.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    if ([[[UTCSStarredEventsManager sharedManager]allEvents]count] == 0) {
        self.descriptionLabel.alpha = 1.0;
        self.tableView.alpha        = 0.0;
    } else {
        self.descriptionLabel.alpha = 0.0;
        self.tableView.alpha        = 1.0;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.doneButton) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEvent *event = [[UTCSStarredEventsManager sharedManager]allEvents][indexPath.row];
    
    // Estimate height of event name
    CGRect rect = [event.name boundingRectWithSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)
                                           options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                        attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                           context:nil];
    
    return MIN(ceilf(rect.size.height), 128.0) + 50.0;
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
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        UTCSEvent *event = [[UTCSStarredEventsManager sharedManager]allEvents][indexPath.row];
        
        if ([self.delegate conformsToProtocol:@protocol(UTCSStarredEventsViewControllerDelegate)] &&
            [self.delegate respondsToSelector:@selector(starredEventsViewController:didSelectEvent:)]) {
            [self.delegate starredEventsViewController:self didSelectEvent:event];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Unstar";
}

@end
