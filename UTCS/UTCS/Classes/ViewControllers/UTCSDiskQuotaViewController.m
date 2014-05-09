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
#import "JVFloatLabeledTextField.h"
#import "PocketSVG.h"
#import "DPMeterView.h"
#import "UTCSUpdateTextFactory.h"


// Categories
#import "UIImage+CZTinting.h"
#import "UIButton+UTCSButton.h"



#pragma mark - Constants

// Key used to cache disk quota
static NSString *diskQuotaCacheKey = @"quota";


#pragma mark - UTCSDiskQuotaViewController Class Extension

@interface UTCSDiskQuotaViewController ()

// Button used to request disk quota information
@property (nonatomic) UIButton                  *goButton;

// Label used to display the user's name
@property (nonatomic) UILabel                   *nameLabel;

// Label used to display the updated time
@property (nonatomic) UILabel                   *updatedLabel;

// Label used to display the usage percentage
@property (nonatomic) UILabel                   *percentLabel;

// 
@property (nonatomic) DPMeterView               *meterView;

// Label used to display a frowny face in case of failure
@property (nonatomic) UILabel                   *frownyFaceLabel;

// Label used to show more detailed disk quota information
@property (nonatomic) UILabel                   *quotaDetailLabel;

// Label used to describe what disk quota is on first usage
@property (nonatomic) UILabel                   *descriptionLabel;

// Label used to display the error message in case of failure
@property (nonatomic) UILabel                   *errorMessageLabel;

// Textfield used to input the user's username
@property (nonatomic) JVFloatLabeledTextField   *usernameTextField;

@end


#pragma mark - UTCSDiskQuotaViewController Implementation

@implementation UTCSDiskQuotaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataSource = [[UTCSDiskQuotaDataSource alloc]initWithService:@"quota"];
        
        // Username text field
        self.usernameTextField = ({
            JVFloatLabeledTextField *textField = [[JVFloatLabeledTextField alloc]initWithFrame:CGRectZero];
            textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"CS Username"
                                                                             attributes:@{  NSForegroundColorAttributeName :
                                                                                            [UIColor colorWithWhite:1.0 alpha:0.5]}];
            textField.floatingLabelTextColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.floatingLabelActiveTextColor = [UIColor whiteColor];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.textColor = [UIColor whiteColor];
            textField.tintColor = [UIColor whiteColor];
            textField.returnKeyType = UIReturnKeyGo;
            textField.delegate = self;
            textField;
        });
        
        // Go button
        self.goButton = ({
            UIButton *button = [UIButton bouncyButton];
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            [button setTitle:@"Go" forState:UIControlStateNormal];
            button.tintColor = [UIColor whiteColor];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4.0;
            button.layer.borderWidth = 1.0;
            button;
        });
        
        // Meter view
        self.meterView = ({
            DPMeterView *view = [DPMeterView new];
            view.trackTintColor = [UIColor colorWithWhite:1.0 alpha:0.2];
            view.shape = [PocketSVG pathFromSVGFileNamed:@"cloud"];
            view.meterType = DPMeterTypeLinearHorizontal;
            view.alpha = 0.0;
            view;
        });
        
        // Name label
        self.nameLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:32];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
        
        // Quota detail label
        self.percentLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:36];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        
        // Quota detail label
        self.quotaDetailLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        
        // Updated label
        self.updatedLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        
        self.descriptionLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.numberOfLines = 0;
            label.text = @"Enter your CS username to check your available disk quota.\n\nYour disk quota represents the amount of available disk space on your Unix account.";
            label;
        });
        
        self.frownyFaceLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:128];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"☹";
            label.alpha = 0.0;
            label;
        });
        
        self.errorMessageLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            label.text = @"Ouch! Something went wrong.\n\nPlease check your CS username and network connection.";
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label.numberOfLines = 0;
            label.alpha = 0.0;
            label;
        });
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.backgroundImageView.image = [UIImage imageNamed:@"diskQuotaBackground"];
    
    self.usernameTextField.frame    = CGRectMake(0.125 * self.view.width, 44.0, 0.5 * self.view.width, 44);
    
    self.goButton.frame             = CGRectMake(0.0, 0.0, 50.0, 28.0);
    self.goButton.center            = CGPointMake(0.85 * self.view.width, self.usernameTextField.center.y);
    
    self.meterView.frame            = CGRectMake(0, 0, 160, 98);
    self.meterView.center           = CGPointMake(self.view.center.x, 0.8 * self.view.center.y);
    
    self.nameLabel.frame            = CGRectMake(16.0, self.view.center.y, self.view.width - 32.0, 48);
    
    self.percentLabel.frame         = CGRectMake(0.0, 0.0, 0.6 * self.view.width, 36);
    self.percentLabel.center        = CGPointMake(self.view.center.x, 1.25 * self.view.center.y);
    
    self.quotaDetailLabel.frame     = CGRectMake(0.0, 0.0, 0.6 * self.view.width, 20);
    self.quotaDetailLabel.center    = CGPointMake(self.view.center.x, 1.375 * self.view.center.y);
    
    self.updatedLabel.frame         = CGRectMake(0.0, self.view.height - 24, self.view.width, 24);
    
    self.descriptionLabel.frame     = CGRectMake(0.0, 0.0, 0.75 * self.view.width, 0.5 * self.view.width);
    self.descriptionLabel.center    = CGPointMake(self.view.center.x, 0.75 * self.view.center.y);
    
    self.frownyFaceLabel.frame      = CGRectMake(0.0, 0.0, 0.5 * self.view.width, 0.5 * self.view.width);
    self.frownyFaceLabel.center     = CGPointMake(self.view.center.x, 0.9 * self.view.center.y);
    
    self.errorMessageLabel.frame    = CGRectMake(0.0, 0.0, 0.75 * self.view.width, 0.5 * self.view.width);
    self.errorMessageLabel.center   = CGPointMake(self.view.center.x, 1.28 * self.view.center.y);
    
    
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.goButton];
    [self.view addSubview:self.meterView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.percentLabel];
    [self.view addSubview:self.quotaDetailLabel];
    [self.view addSubview:self.updatedLabel];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.frownyFaceLabel];
    [self.view addSubview:self.errorMessageLabel];
    
    
    CAShapeLayer *lineSeparatorLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0.1 * self.view.width, 88.0, 0.8 * self.view.width, 0.5)].CGPath;
        layer.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
        layer.fillColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
        layer.strokeStart = 0.0;
        layer.strokeEnd = 1.0;
        layer;
    });
    [self.view.layer addSublayer:lineSeparatorLayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.meterView startGravity];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.meterView stopGravity];
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.goButton) {
        [self.view endEditing:YES];
        if ([self.usernameTextField.text length]) {
            [self update];
        }
    }
}

#pragma mark Updating

- (void)update
{
    if ([self.dataSource shouldUpdate]) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = [UTCSUpdateTextFactory randomUpdateText];
        
        [self updateWithArgument:self.usernameTextField.text completion:^(BOOL success, BOOL cacheHit) {
            
            if (success) {
                self.nameLabel.text = self.dataSource.data[@"name"];
                CGFloat limit = [self.dataSource.data[@"limit"]floatValue];
                CGFloat usage = [self.dataSource.data[@"usage"]floatValue];
                CGFloat percentUsage = (usage / limit);
                
                self.meterView.progressTintColor = [UIColor whiteColor];
                [self.meterView setProgress:percentUsage animated:YES];

                self.percentLabel.text      = [NSString stringWithFormat:@"%0.2f%%", 100 * (usage / limit)];
                self.quotaDetailLabel.text  = [NSString stringWithFormat:@"%.0f / %.0f MB", usage, limit];
                
                
                NSString *updatedString = [NSDateFormatter localizedStringFromDate:self.dataSource.updated
                                                                         dateStyle:NSDateFormatterLongStyle
                                                                         timeStyle:NSDateFormatterMediumStyle];
                self.updatedLabel.text = [NSString stringWithFormat:@"Updated %@", updatedString];
            } else {
                self.updatedLabel.text = @"Update Failed";
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.frownyFaceLabel.alpha      = !success;
                self.errorMessageLabel.alpha    = !success;
                self.quotaDetailLabel.alpha     = success;
                self.percentLabel.alpha         = success;
                self.meterView.alpha            = success;
                self.nameLabel.alpha            = success;
                self.descriptionLabel.alpha     = 0.0;
            }];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

#pragma mark UIResponder Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self update];
    [textField resignFirstResponder];
    return YES;
}

@end
