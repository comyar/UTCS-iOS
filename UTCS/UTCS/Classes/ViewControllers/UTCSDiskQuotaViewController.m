//
//  UTCSDiskQuotaViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/2/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// View Controllers
#import "UTCSDiskQuotaViewController.h"

// Views
#import "MBProgressHUD.h"
#import "UTCSMenuButton.h"
#import "MRCircularProgressView.h"

// Models
#import "UTCSCacheManager.h"
#import "UTCSDataRequestServicer.h"

// Categories
#import "UIView+Shake.h"
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"


#pragma mark - Constants

// Key used to cache disk quota
static NSString *diskQuotaCacheKey = @"quota";

// Minimum time between updates, in seconds
static CGFloat minimumTimeBetweenUpdates    = 10800.0;  // 3 hours


#pragma mark - UTCSDiskQuotaViewController Class Extension

@interface UTCSDiskQuotaViewController ()

@property (nonatomic) NSDictionary              *quota;

// Date formatter
@property (nonatomic) NSDateFormatter   *dateFormatter;

// -----
// @name Views
// -----

@property (nonatomic) UILabel                   *nameLabel;

@property (nonatomic) UILabel                   *unitLabel;

@property (nonatomic) UILabel                   *usernameLabel;

@property (nonatomic) UILabel                   *updatedLabel;

@property (nonatomic) UILabel                   *diskQuotaDetailLabel;

@property (nonatomic) MRCircularProgressView    *diskQuotaGaugeView;

// Image view used to display the background image
@property (nonatomic) UIImageView               *backgroundImageView;

// Button used to display the menu view controller
@property (nonatomic) UTCSMenuButton            *menuButton;

@end


#pragma mark - UTCSDiskQuotaViewController Implementation

@implementation UTCSDiskQuotaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dateFormatter = ({
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss"; // Ex: 2014-04-19 14:27:47
            dateFormatter;
        });
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background image view
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"diskQuotaBackground"]tintedImageWithColor:[UIColor colorWithWhite:0.11 alpha:0.73] blendingMode:kCGBlendModeOverlay]];
        [self.view addSubview:imageView];
        imageView;
    });
    
    // Menu Button
    self.menuButton = ({
        UTCSMenuButton *button = [UTCSMenuButton new];
        button.lineColor = [UIColor whiteColor];
        [self.view addSubview:button];
        button;
    });
    
    self.diskQuotaGaugeView = ({
        MRCircularProgressView *view = [[MRCircularProgressView alloc]initWithFrame:CGRectMake(0, 0, 0.625 * self.view.width,
                                                                                               0.625 * self.view.width)];
        view.center = self.view.center;
        view.backgroundColor = [UIColor clearColor];
        view.progressColor = [UIColor whiteColor];
        view.progressArcWidth = 8.0;
        view.alpha = 0.0;
        [self.view addSubview:view];
        view;
    });
    
    self.usernameLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.6 * self.view.width, 18)];
        label.center = CGPointMake(self.view.center.x, 0.9 * self.view.center.y - self.view.y);
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        label;
    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 128.0, self.view.width, 24)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:label];
        label;
    });
    
    self.diskQuotaDetailLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.6 * self.view.width, 24)];
        label.center = CGPointMake(self.view.center.x, self.view.center.y - self.view.y);
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        label;
    });
    
    self.unitLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.6 * self.view.width, 14)];
        label.center = CGPointMake(self.view.center.x, 1.08 * self.view.center.y - self.view.y);
        label.text = @"MB";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        label;
    });
    
    self.updatedLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, self.view.height - 24, self.view.width, 24)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self.view addSubview:label];
        label;
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Disk Quota

- (void)update
{
    NSDictionary *cache = [UTCSCacheManager cacheForService:UTCSEventsService withKey:diskQuotaCacheKey];
    UTCSCacheMetaData *metaData = cache[UTCSCacheMetaDataName];
    
    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < minimumTimeBetweenUpdates) {
        NSLog(@"Quota : Cache hit");
        
        self.quota = cache[UTCSCacheValuesName];
        [self updateUserInterfaceWithQuota:self.quota updated:metaData.timestamp];
        
        return;
    }
    
    NSLog(@"Quota : Cache miss");
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.labelText = (metaData) ? @"Updating" : @"Downloading";
    [UTCSDataRequestServicer sendDataRequestWithType:UTCSDataRequestDiskQuota argument:@"czaheri" success:^(NSDictionary *meta, NSDictionary *values) {
        if ([meta[@"service"] isEqualToString:UTCSDiskQuotaService] && meta[@"success"]) {
            self.quota = values;
            [UTCSCacheManager cacheObject:self.quota forService:UTCSDiskQuotaService withKey:diskQuotaCacheKey];
            [self updateUserInterfaceWithQuota:self.quota updated:[NSDate date]];
        }
        [progressHUD hide:YES];
    } failure:^(NSError *error) {
        [self updateUserInterfaceWithQuota:cache[UTCSCacheValuesName] updated:[NSDate date]];
        [progressHUD hide:YES];
    }];
}

- (void)updateUserInterfaceWithQuota:(NSDictionary *)quota updated:(NSDate *)updated
{
    if (!quota) {
        NSLog(@"no cache, failed download");
    } else {
        CGFloat limit = [quota[@"limit"]floatValue];
        CGFloat usage = [quota[@"usage"]floatValue];
        NSString *user = quota[@"user"];
        NSString *name = quota[@"name"];
        
        self.nameLabel.text = name;
        self.usernameLabel.text = user;
        self.diskQuotaDetailLabel.text = [NSString stringWithFormat:@"%.0f / %.0f", usage, limit];
        
        NSString *updateString = [NSDateFormatter localizedStringFromDate:updated
                                                                dateStyle:NSDateFormatterMediumStyle
                                                                timeStyle:NSDateFormatterShortStyle];
        self.updatedLabel.text = [NSString stringWithFormat:@"Updated : %@", updateString];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.diskQuotaGaugeView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.diskQuotaGaugeView setProgress:(usage / limit) animated:YES];
        }];
    }
}


#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
