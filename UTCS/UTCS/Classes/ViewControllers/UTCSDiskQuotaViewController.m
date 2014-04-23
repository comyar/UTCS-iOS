//
//  UTCSDiskQuotaViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/2/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports


#import "UTCSDiskQuotaViewController.h"

#import "UTCSDiskQuotaDataSource.h"

#import "MBProgressHUD.h"
#import "MRCircularProgressView.h"

// Categories
#import "UIImage+CZTinting.h"


#pragma mark - Constants

// Key used to cache disk quota
static NSString *diskQuotaCacheKey = @"quota";


#pragma mark - UTCSDiskQuotaViewController Class Extension

@interface UTCSDiskQuotaViewController ()

@property (nonatomic) UTCSButton                *goButton;

@property (nonatomic) UILabel                   *nameLabel;

@property (nonatomic) UILabel                   *unitLabel;

@property (nonatomic) UILabel                   *usernameLabel;

@property (nonatomic) UILabel                   *updatedLabel;

@property (nonatomic) UILabel                   *quotaDetailLabel;

@property (nonatomic) MRCircularProgressView    *quotaGaugeView;

@property (nonatomic) UITextField               *usernameTextField;

@property (nonatomic) UILabel                   *frownyFaceLabel;

@property (nonatomic) UILabel                   *errorMessageLabel;

@property (nonatomic) UILabel                   *descriptionLabel;

@end


#pragma mark - UTCSDiskQuotaViewController Implementation

@implementation UTCSDiskQuotaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataSource = [[UTCSDiskQuotaDataSource alloc]initWithService:@"quota"];
        
        // Username text field
        self.usernameTextField = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectZero];
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.placeholder = @"CS Unix Username";
            textField.textColor = [UIColor whiteColor];
            textField.tintColor = [UIColor whiteColor];
            textField;
        });
        
        // Go button
        self.goButton = ({
            UTCSButton *button = [[UTCSButton alloc]initWithFrame:CGRectZero];
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"goButton"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            imageView.tintColor = [UIColor whiteColor];
            [button addSubview:imageView];
            
            button;
        });
        
        // Quota circular view
        self.quotaGaugeView = ({
            MRCircularProgressView *view = [[MRCircularProgressView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor clearColor];
            view.progressColor = [UIColor whiteColor];
            view.progressArcWidth = 8.0;
            view.alpha = 0.0;
            view;
        });
        
        // Name label
        self.nameLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.textAlignment = NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
        
        // Quota detail label
        self.quotaDetailLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        
        // Unit label
        self.unitLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.text = @"MB";
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.alpha = 0.0;
            label;
        });
        
        // Updated label
        self.updatedLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label;
        });
        
        self.descriptionLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.numberOfLines = 0;
            label.text = @"Enter your CS Unix username to check your available disk quota.\n\nYour disk quota represents the amount of available disk space for your Unix account.";
            label;
        });
        
        self.frownyFaceLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:128];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"☹";
            label;
        });
        
        self.errorMessageLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.text = @"Ouch! Something went wrong.\n\nPlease check your Unix username and network connection.";
            label.numberOfLines = 0;
            label;
        });
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView.image = [UIImage imageNamed:@"diskQuotaBackground"];

    [self.view addSubview:self.usernameTextField];

    [self.view addSubview:self.goButton];
    
    [self.view addSubview:self.quotaGaugeView];
    
    [self.view addSubview:self.nameLabel];
    
    [self.view addSubview:self.quotaDetailLabel];
    
    [self.view addSubview:self.unitLabel];
    
    [self.view addSubview:self.updatedLabel];
    
    [self.view addSubview:self.descriptionLabel];
    
    [self.view addSubview:self.frownyFaceLabel];
    [self.view addSubview:self.errorMessageLabel];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.usernameTextField.frame = CGRectMake(0.125 * self.view.width, 44.0, 0.5 * self.view.width, 44);
    
    self.goButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    self.goButton.center = CGPointMake(0.85 * self.view.width, self.usernameTextField.center.y);
    
    self.quotaGaugeView.frame = CGRectMake(0, 0, 0.625 * self.view.width, 0.625 * self.view.width);
    self.quotaGaugeView.center = self.view.center;
    
    self.nameLabel.frame = CGRectMake(0.0, 128.0, self.view.width, 48);
    
    self.quotaDetailLabel.frame = CGRectMake(0.0, 0.0, 0.6 * self.view.width, 24);
    self.quotaDetailLabel.center = CGPointMake(self.view.center.x, self.view.center.y - self.view.y);
    
    self.unitLabel.frame = CGRectMake(0.0, 0.0, 0.6 * self.view.width, 14);
    self.unitLabel.center = CGPointMake(self.view.center.x, 1.08 * self.view.center.y - self.view.y);
    
    self.updatedLabel.frame = CGRectMake(0.0, self.view.height - 24, self.view.width, 24);
    
    
    self.descriptionLabel.frame = CGRectMake(0.0, 0.0, 0.75 * self.view.width, 0.5 * self.view.width);
    self.descriptionLabel.center = self.view.center;

    
    self.frownyFaceLabel.frame = CGRectMake(0.0, 0.0, 0.5 * self.view.width, 0.5 * self.view.width);
    self.frownyFaceLabel.center = CGPointMake(self.view.center.x, 0.9 * self.view.center.y);
    
    self.errorMessageLabel.frame = CGRectMake(0.0, 0.0, 0.75 * self.view.width, 0.5 * self.view.width);
    self.errorMessageLabel.center = CGPointMake(self.view.center.x, 1.24 * self.view.center.y);
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.goButton) {
        [self.view endEditing:YES];
        [self update];
    }
}

- (void)update
{
    if ([self.dataSource shouldUpdate]) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = @"Updating";
        
        [self updateWithArgument:self.usernameTextField.text completion:^(BOOL success) {
            
            if (success) {
                self.nameLabel.text = self.dataSource.data[@"name"];
                CGFloat limit = [self.dataSource.data[@"limit"]floatValue];
                CGFloat usage = [self.dataSource.data[@"usage"]floatValue];
                [self.quotaGaugeView setProgress:(usage / limit) animated:YES];
                self.quotaDetailLabel.text = [NSString stringWithFormat:@"%0.0f / %0.0f", usage, limit];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.quotaDetailLabel.alpha = 1.0;
                    self.quotaGaugeView.alpha = 1.0;
                    self.unitLabel.alpha = 1.0;
                }];
                
                NSString *updatedString = [NSDateFormatter localizedStringFromDate:self.dataSource.updated
                                                                         dateStyle:NSDateFormatterLongStyle
                                                                         timeStyle:NSDateFormatterMediumStyle];
                self.updatedLabel.text = [NSString stringWithFormat:@"Updated %@", updatedString];
            } else {
                
                self.updatedLabel.text = @"Update Failed";
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.frownyFaceLabel.alpha = 1.0;
                    self.errorMessageLabel.alpha = 1.0;
                    self.quotaGaugeView.alpha = 0.0;
                    self.quotaDetailLabel.alpha = 0.0;
                    self.unitLabel.alpha = 0.0;
                }];
                
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                self.descriptionLabel.alpha = 0.0;
            }];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
