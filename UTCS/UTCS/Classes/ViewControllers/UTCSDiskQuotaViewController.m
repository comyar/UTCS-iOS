//
//  UTCSDiskQuotaViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/2/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDiskQuotaViewController.h"
#import "UTCSMenuButton.h"
#import "MRCircularProgressView.h"
#import "UIView+CZPositioning.h"
#import "UTCSSSHManager.h"
#import "UTCSAccountManager.h"
#import "UTCSDiskQuotaAuthenticationViewController.h"
#import "UIColor+UTCSColors.h"
#import "UIImage+CZTinting.h"


@interface UTCSDiskQuotaViewController ()
@property (nonatomic) UIImageView       *backgroundImageView;
@property (nonatomic) CGFloat           currentQuota;
@property (nonatomic) UTCSMenuButton    *menuButton;
@property (nonatomic) UIButton          *updateButton;
@property (nonatomic) MRCircularProgressView *diskQuotaGaugeView;
@property (nonatomic) UILabel           *diskQuotaDetailLabel;
@property (nonatomic) UILabel           *updatedLabel;
@property (nonatomic) UTCSDiskQuotaAuthenticationViewController *diskQuotaAuthenticationViewController;
@end

@implementation UTCSDiskQuotaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)didAuthenticate
{
    [self.navigationController popToViewController:self animated:YES];
    [self updateDiskQuota];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if(![UTCSAccountManager password]) {
        if(!self.diskQuotaAuthenticationViewController) {
            self.diskQuotaAuthenticationViewController = [UTCSDiskQuotaAuthenticationViewController new];
            self.diskQuotaAuthenticationViewController.delegate = self;
        }
//        [self.navigationController pushViewController:self.diskQuotaAuthenticationViewController animated:NO];
    }
}

- (void)updateDiskQuota
{
    NSString *username = [UTCSAccountManager username];
    NSString *password = [UTCSAccountManager password];
    [[UTCSSSHManager sharedSSHManager]connectWithUsername:username password:password completion:^(BOOL success) {
        if(success) {
            [[UTCSSSHManager sharedSSHManager]executeCommand:@"chkquota" completion:^(NSString *response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@", response);
                    CGFloat limit = [self diskLimitForResponse:response];
                    CGFloat usage = [self diskUsageForResponse:response];
                    [self.diskQuotaGaugeView setProgress:(usage/limit) animated:YES];
                    self.updatedLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                            dateStyle:NSDateFormatterMediumStyle
                                                                            timeStyle:NSDateFormatterMediumStyle];
                });
                [[UTCSSSHManager sharedSSHManager]disconnect];
            }];
        } else {
            self.updatedLabel.text = @"Update Failed. Check Your Network Connection.";
        }
    }];
}

- (CGFloat)diskLimitForResponse:(NSString *)response
{
    CGFloat limit = 0.0;
    NSArray *lines = [response componentsSeparatedByString:@"\n"];
    if([lines count] >= 2) {
        NSString *line = lines[1];
        NSArray *components = [line componentsSeparatedByString:@" "];
        if([components count] >= 3) {
            limit = [components[2] floatValue];
        }
    }
    return limit;
}

- (CGFloat)diskUsageForResponse:(NSString *)response
{
    CGFloat usage = 0.0;
    NSArray *lines = [response componentsSeparatedByString:@"\n"];
    if([lines count] >= 3) {
        NSString *line = lines[2];
        NSArray *components = [line componentsSeparatedByString:@" "];
        if([components count] >= 3) {
            usage = [components[2] floatValue];
        }
    }
    return usage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"diskQuotaBackground"]tintedImageWithColor:[UIColor colorWithWhite:0.11 alpha:0.73] blendingMode:kCGBlendModeOverlay]];
        [self.view addSubview:imageView];
        imageView;
    });
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
    self.menuButton.lineColor = [UIColor whiteColor];
    [self.view addSubview:self.menuButton];
    
    self.diskQuotaGaugeView = ({
        MRCircularProgressView *view = [[MRCircularProgressView alloc]initWithFrame:CGRectMake(0, 0, 0.7 * self.view.width,
                                                                                               0.7 * self.view.width)];
        view.center = self.view.center;
        view.backgroundColor = [UIColor clearColor];
        view.progressColor = [UIColor whiteColor];
        view.progressArcWidth = 8.0;
        [self.view addSubview:view];
        view;
    });
    
    self.diskQuotaDetailLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.6, 36)];
        label.center = self.view.center;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    self.updateButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0.0, 0.0, 0.5 * self.view.width, 44.0);
        button.center = CGPointMake(self.view.center.x, 1.6 * self.view.center.y);
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.cornerRadius = 10.0;
        [button setTitle:@"Update" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(updateDiskQuota) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.updateButton];
    
    self.updatedLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, self.view.height - 24, self.view.width, 24)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label;
    });
    
    
}

@end
