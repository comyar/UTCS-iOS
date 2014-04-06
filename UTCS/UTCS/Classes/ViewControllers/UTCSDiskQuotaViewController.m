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
#import "UTCSSSHManager.h"
#import "UTCSAccountManager.h"

// Categories
#import "UIView+Shake.h"
#import "UIImage+CZTinting.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"


#pragma mark - UTCSDiskQuotaViewController Class Extension

@interface UTCSDiskQuotaViewController ()

// Button used to display the menu view controller
@property (nonatomic) UTCSMenuButton            *menuButton;

// Label displaying the title of the view controller
@property (nonatomic) UILabel                   *titleLabel;

// Image view used to display the background image
@property (nonatomic) UIImageView               *backgroundImageView;

// -----
// @name Authentication Properties
// -----

// Button used to begin authentication
@property (nonatomic) UIButton                  *loginButton;

// Textfield used to input username
@property (nonatomic) UITextField               *usernameTextField;

// Textfield used to input password
@property (nonatomic) UITextField               *passwordTextField;

// Aesthetic view used to draw a separating line between the username and password text fields
@property (nonatomic) UIView                    *textFieldSeparatorView;

//
@property (nonatomic) UIView                    *authenticationContainerView;

//
@property (nonatomic, getter = isEnteringCredentials) BOOL enteringCredentials;

// -----
// @name Disk Quota Properties
// -----

@property (nonatomic) CGFloat                   currentQuota;

@property (nonatomic) UIView                    *diskQuotaContainerView;

@property (nonatomic) UIButton                  *updateButton;

@property (nonatomic) MRCircularProgressView    *diskQuotaGaugeView;

@property (nonatomic) UILabel                   *diskQuotaDetailLabel;

@property (nonatomic) UILabel                   *updatedLabel;

@property (nonatomic) UILabel                   *usernameLabel;

@property (nonatomic) UILabel                   *unitLabel;

@property (nonatomic) UILabel                   *nameLabel;

@end


#pragma mark - UTCSDiskQuotaViewController Implementation

@implementation UTCSDiskQuotaViewController

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
        UTCSMenuButton *button = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
        button.lineColor = [UIColor whiteColor];
        [self.view addSubview:button];
        button;
    });
    
    // Title label
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.1 * self.view.height, self.view.width, 100)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:58.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Disk Quota";
        [self.view addSubview:label];
        label;
    });
    
    // Disk quota subviews
    [self initDiskQuotaSubviews];
    
    // Authentication subviews
    [self initAuthenticationSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([UTCSAccountManager password]) {
        self.diskQuotaContainerView.alpha = 1.0;
    } else {
        self.authenticationContainerView.alpha = 1.0;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self adjustAuthenticationSubviewsWhileEditing:NO];
}

#pragma mark UIButton Methods

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.loginButton) {
        [self.view endEditing:YES];
        [self adjustAuthenticationSubviewsWhileEditing:NO];
        [self authenticateWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
    }
}

#pragma mark - Disk Quota

- (void)updateDiskQuota
{
    NSString *username = [UTCSAccountManager username];
    NSString *password = [UTCSAccountManager password];
    [self updateDiskQuotaWithUsername:username password:password];
}

- (void)updateDiskQuotaWithUsername:(NSString *)username password:(NSString *)password
{
    [[UTCSSSHManager sharedSSHManager]connectWithUsername:username password:password completion:^(BOOL success) {
        if(success) {
            [[UTCSSSHManager sharedSSHManager]executeCommand:@"chkquota" completion:^(NSString *response) {
                CGFloat limit = [self diskLimitForResponse:response];
                CGFloat usage = [self diskUsageForResponse:response];
                NSString *command = [NSString stringWithFormat:@"finger %@", username];
                [[UTCSSSHManager sharedSSHManager]executeCommand:command completion:^(NSString *response) {
                    [[UTCSSSHManager sharedSSHManager]disconnect];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *name = [self nameForResponse:response];
                        [UTCSAccountManager setName:name];
                        self.nameLabel.text = name;
                        self.usernameLabel.text = username;
                        self.diskQuotaDetailLabel.text = [NSString stringWithFormat:@"%0.f / %0.0f", usage, limit];
                        [self.diskQuotaGaugeView setProgress:(usage/limit) animated:YES];
                        NSString *updatedTime = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                                dateStyle:NSDateFormatterMediumStyle
                                                                                timeStyle:NSDateFormatterMediumStyle];
                        self.updatedLabel.text = [NSString stringWithFormat:@"Updated: %@", updatedTime];
                    });
                }];
            }];
        } else {
            self.updatedLabel.text = @"Update Failed. Check Your Network Connection.";
            [[UTCSSSHManager sharedSSHManager]disconnect];
        }
    }];
}

- (NSString *)nameForResponse:(NSString *)response
{
    NSString *name = nil;
    NSLog(@"%@", response);
    NSArray *lines = [response componentsSeparatedByString:@"\n"];
    NSLog(@"%@", lines);
    if([lines count] >= 1) {
        NSString *line = lines[0];
        NSLog(@"%@", line);
        NSArray *components = [line componentsSeparatedByString:@":"];
        NSInteger lastIndex = [components count] - 1;
        if(lastIndex >= 0) {
            name = [components[lastIndex] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    NSLog(@"%@", name);
    return name;
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

- (void)initDiskQuotaSubviews
{
    self.diskQuotaContainerView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44.0, self.view.width, self.view.height - 44.0)];
        view.backgroundColor = [UIColor clearColor];
        view.alpha = 0.0;
        [self.view addSubview:view];
        view;
    });
    
    self.diskQuotaGaugeView = ({
        MRCircularProgressView *view = [[MRCircularProgressView alloc]initWithFrame:CGRectMake(0, 0, 0.625 * self.view.width,
                                                                                               0.625 * self.view.width)];
        view.center = CGPointMake(self.diskQuotaContainerView.center.x, self.diskQuotaContainerView.center.y - self.diskQuotaContainerView.y);
        view.backgroundColor = [UIColor clearColor];
        view.progressColor = [UIColor whiteColor];
        view.progressArcWidth = 8.0;
        [self.diskQuotaContainerView addSubview:view];
        view;
    });
    
    self.usernameLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.6 * self.diskQuotaContainerView.width, 18)];
        label.center = CGPointMake(self.diskQuotaContainerView.center.x, 0.9 * self.diskQuotaContainerView.center.y - self.diskQuotaContainerView.y);
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        [self.diskQuotaContainerView addSubview:label];
        label;
    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 90.0, self.diskQuotaContainerView.width, 24)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        [self.diskQuotaContainerView addSubview:label];
        label;
    });
    
    self.diskQuotaDetailLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.6 * self.diskQuotaContainerView.width, 24)];
        label.center = CGPointMake(self.diskQuotaContainerView.center.x, self.diskQuotaContainerView.center.y - self.diskQuotaContainerView.y);
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.diskQuotaContainerView addSubview:label];
        label;
    });
    
    self.unitLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.6 * self.diskQuotaContainerView.width, 14)];
        label.center = CGPointMake(self.diskQuotaContainerView.center.x, 1.08 * self.diskQuotaContainerView.center.y - self.diskQuotaContainerView.y);
        label.text = @"MB";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.diskQuotaContainerView addSubview:label];
        label;
    });
    
    self.updateButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0.0, 0.0, 0.5 * self.diskQuotaContainerView.width, 44.0);
        button.center = CGPointMake(self.diskQuotaContainerView.center.x, 1.4 * self.diskQuotaContainerView.center.y);
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.cornerRadius = 10.0;
        [button setTitle:@"Update" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(updateDiskQuota) forControlEvents:UIControlEventTouchUpInside];
        [self.diskQuotaContainerView addSubview:button];
        button;
    });
    
    self.updatedLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, self.diskQuotaContainerView.height - 24, self.diskQuotaContainerView.width, 24)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self.diskQuotaContainerView addSubview:label];
        label;
    });
}

#pragma mark - Authentication

- (void)initAuthenticationSubviews
{
    // Disk quota authentication container view
    self.authenticationContainerView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44.0, self.view.width, self.view.height - 44.0)];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        view.alpha = 0.0;
        view;
    });
    
    // Username text field
    self.usernameTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.5 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.authenticationContainerView.center.x,
                                       self.authenticationContainerView.center.y - 0.5 * CGRectGetHeight(textField.bounds) - 44.0);
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.tintColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        textField.textColor = [UIColor whiteColor];
        textField.returnKeyType = UIReturnKeyNext;
        textField.delegate = self;
        
        // Placeholder
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"username"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1.0 alpha:0.8]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
        textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        textField.attributedPlaceholder = attributedPlaceholder;
        
        [self.authenticationContainerView addSubview:textField];
        textField;
    });
    
    // Textfield separator view
    self.textFieldSeparatorView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.5 * CGRectGetWidth(self.view.bounds), 0.5)];
        view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        view.center = CGPointMake(self.authenticationContainerView.center.x,
                                  self.authenticationContainerView.center.y - 44.0);
        [self.authenticationContainerView addSubview:view];
        view;
    });
    
    // Password text field
    self.passwordTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.5 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.authenticationContainerView.center.x,
                                       self.authenticationContainerView.center.y + 0.5 * CGRectGetHeight(textField.bounds) - 44.0);
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.tintColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        textField.textColor = [UIColor whiteColor];
        textField.returnKeyType = UIReturnKeyDone;
        textField.secureTextEntry = YES;
        textField.delegate = self;
        
        // Placeholder
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"password"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1.0 alpha:0.8]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
        textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        textField.attributedPlaceholder = attributedPlaceholder;
        
        [self.authenticationContainerView addSubview:textField];
        textField;
    });
    
    // Login button
    self.loginButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0.0, 0.0, 0.5 * self.authenticationContainerView.width, 44.0);
        button.center = CGPointMake(self.authenticationContainerView.center.x, 1.25 * self.authenticationContainerView.center.y);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [button setTitle:@"Login" forState:UIControlStateNormal];
        button.layer.cornerRadius = 10.0;
        button.layer.borderWidth = 0.75;
        [self.authenticationContainerView addSubview:button];
        button;
    });
}

- (void)adjustAuthenticationSubviewsWhileEditing:(BOOL)editing
{
    CGPoint loginOffset = (editing)? CGPointMake(self.view.center.x, 0.5 * self.view.center.y) : self.view.center;
    CGFloat titleAlpha = (editing)? 0.0 : 1.0;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.authenticationContainerView.center = loginOffset;
        self.titleLabel.alpha = titleAlpha;
    } completion:nil];
}

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UTCSSSHManager sharedSSHManager]connectWithUsername:username password:password completion:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(success) {
                [self.view endEditing:YES];
                [UIView animateWithDuration:0.3 animations:^{
                    self.authenticationContainerView.alpha = 0.0;
                    self.diskQuotaContainerView.alpha = 1.0;
                }];
            
                [self updateDiskQuotaWithUsername:username password:password];
                [UTCSAccountManager setUsername:username];
                [UTCSAccountManager setPassword:password];
            } else {
                [self.authenticationContainerView shake:3 withDelta:16.0];
                // Creates Vibration
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!self.enteringCredentials) {
        [self adjustAuthenticationSubviewsWhileEditing:YES];
    }
    self.enteringCredentials = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.passwordTextField) {
        if(!self.enteringCredentials) {
            [self adjustAuthenticationSubviewsWhileEditing:NO];
        }
    }
    self.enteringCredentials = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if(textField == self.passwordTextField) {
        [self adjustAuthenticationSubviewsWhileEditing:NO];
        [self authenticateWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
    }
    return YES;
}

@end
