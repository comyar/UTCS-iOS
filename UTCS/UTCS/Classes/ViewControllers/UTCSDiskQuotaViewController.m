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

@property (nonatomic) UITextField               *usernameTextField;

@property (nonatomic) UTCSButton                *goButton;

@property (nonatomic) UILabel                   *nameLabel;

@property (nonatomic) UILabel                   *unitLabel;

@property (nonatomic) UILabel                   *usernameLabel;

@property (nonatomic) UILabel                   *updatedLabel;

@property (nonatomic) UILabel                   *diskQuotaDetailLabel;

@property (nonatomic) MRCircularProgressView    *diskQuotaGaugeView;

@end


#pragma mark - UTCSDiskQuotaViewController Implementation

@implementation UTCSDiskQuotaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView.image = [UIImage imageNamed:@"diskQuotaBackground"];
    
    
    self.usernameTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.125 * self.view.width, 44.0, 0.5 * self.view.width, 44)];
        textField.placeholder = @"CS Unix Username";
        textField;
    });
    [self.view addSubview:self.usernameTextField];
    
    self.goButton = ({
        UTCSButton *button = [[UTCSButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"goButton"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        imageView.tintColor = [UIColor whiteColor];
        [button addSubview:imageView];
        
        button.center = CGPointMake(0.85 * self.view.width, self.usernameTextField.center.y);
        button;
    });
    [self.view addSubview:self.goButton];
    
    
    
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

- (void)update
{
    if ([self.dataSource shouldUpdate]) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = @"Updating";
        
        [self updateWithArgument:nil completion:^(BOOL success) {
            
            if (success) {
                
            } else {
                NSLog(@"quota failed");
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
