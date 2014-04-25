//
//  UTCSEventsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// View controllers
#import "UTCSEventsViewController.h"
#import "UTCSEventDetailViewController.h"

// Views
#import "UTCSMenuButton.h"

// Models
#import "UTCSEvent.h"
#import "UTCSEventsDataSource.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"


#pragma mark - Constants

// Duration of animations performed by this view controller
static const CGFloat animationDuration              = 0.3;

// Name of the background image
static NSString * const backgroundImageName         = @"eventsBackground2";

// Name of the blurred background image
static NSString * const backgroundBlurredImageName  = @"eventsBackground2-blurred";


#pragma mark - UTCSEventsViewController Class Extension

@interface UTCSEventsViewController ()

//
@property (nonatomic) UTCSEventDetailViewController         *eventDetailViewController;

@end


#pragma mark - UTCSEventsViewController Implementation

@implementation UTCSEventsViewController

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
    
        self.dataSource                 = [[UTCSEventsDataSource alloc]initWithService:@"events"];
        self.tableView.dataSource       = (UTCSEventsDataSource *)self.dataSource;
        self.tableView.delegate         = self;
        
        self.backgroundImageView.image          = [UIImage imageNamed:backgroundImageName];
        self.backgroundBlurredImageView.image   = [UIImage imageNamed:backgroundBlurredImageName];
        
        self.activeHeaderView = [[UTCSActiveHeaderView alloc]initWithFrame:self.tableView.bounds];
        ((UILabel *)self.activeHeaderView.shimmeringView.contentView).text = @"UTCS Events";
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

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
                // Show frowny face
            }
            
            self.activeHeaderView.updatedLabel.text = @"No Events Available";
        }
        
        [self.tableView reloadData];
        
    }];
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEvent *event = self.dataSource.data[indexPath.row];
    
    // Estimate height of event name
    CGRect rect = [event.name boundingRectWithSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                                context:nil];
    
    return MIN(ceilf(rect.size.height), 128.0) + 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selected = NO;
//    
//    UTCSEvent *event = self.dataSource.data[indexPath.row];
//    self.eventDetailViewController = [UTCSEventDetailViewController new];
//    self.eventDetailViewController.event = event;
//    [self.navigationController pushViewController:self.eventDetailViewController animated:YES];
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
