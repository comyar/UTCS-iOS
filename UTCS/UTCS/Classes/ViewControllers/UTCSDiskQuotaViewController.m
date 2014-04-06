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
#import "UIView+Shake.h"
#import "MBProgressHUD.h"


@interface UTCSDiskQuotaViewController ()

// Label displaying the title of the view controller
@property (nonatomic, getter = isEnteringCredentials) BOOL enteringCredentials;
@property (nonatomic) UILabel                   *titleLabel;
@property (nonatomic) UIView                    *diskQuotaContainerView;
@property (nonatomic) UIView                    *diskQuotaAuthenticationContainerView;
@property (nonatomic) UIImageView               *backgroundImageView;
@property (nonatomic) CGFloat                   currentQuota;
@property (nonatomic) UTCSMenuButton            *menuButton;
@property (nonatomic) UIButton                  *updateButton;
@property (nonatomic) MRCircularProgressView    *diskQuotaGaugeView;
@property (nonatomic) UILabel                   *diskQuotaDetailLabel;
@property (nonatomic) UILabel                   *updatedLabel;
@property (nonatomic) UTCSDiskQuotaAuthenticationViewController *diskQuotaAuthenticationViewController;


// Button used to begin authentication
@property (nonatomic) UIButton                  *loginButton;

// Textfield used to input username
@property (nonatomic) UITextField               *usernameTextField;

// Textfield used to input password
@property (nonatomic) UITextField               *passwordTextField;

// View containing the usernameTextField, passwordTextField, and textFieldSeparatorView
@property (nonatomic) UIView                    *loginContainerView;

// Aesthetic view used to draw a separating line between the username and password text fields
@property (nonatomic) UIView                    *textFieldSeparatorView;

@end

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
    
    [self initDiskQuotaSubviews];
    [self initAuthenticationSubviews];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self adjustSubviewsWhileEditing:NO];
}

- (void)didAuthenticate
{
    [self.navigationController popToViewController:self animated:YES];
    [self updateDiskQuota];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([UTCSAccountManager password]) {
        self.diskQuotaContainerView.alpha = 1.0;
    } else {
        self.diskQuotaAuthenticationContainerView.alpha = 1.0;
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
                    self.diskQuotaDetailLabel.text = [NSString stringWithFormat:@"%0.f / %0.2f", usage, limit];
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



#pragma mark - Disk Quota

- (void)initDiskQuotaSubviews
{
    self.diskQuotaContainerView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.alpha = 0.0;
        [self.view addSubview:view];
        view;
    });
    
    self.diskQuotaGaugeView = ({
        MRCircularProgressView *view = [[MRCircularProgressView alloc]initWithFrame:CGRectMake(0, 0, 0.7 * self.view.width,
                                                                                               0.7 * self.view.width)];
        view.center = self.view.center;
        view.backgroundColor = [UIColor clearColor];
        view.progressColor = [UIColor whiteColor];
        view.progressArcWidth = 8.0;
        [self.diskQuotaContainerView addSubview:view];
        view;
    });
    
    self.diskQuotaDetailLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.6, 36)];
        label.center = self.view.center;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.diskQuotaContainerView addSubview:label];
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
        [self.diskQuotaContainerView addSubview:button];
        button;
    });
    
    
    self.updatedLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, self.view.height - 24, self.view.width, 24)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [self.diskQuotaContainerView addSubview:label];
        label;
    });
}


#pragma mark - Authentication


- (void)initAuthenticationSubviews
{
    // Disk quota authentication container view
    self.diskQuotaAuthenticationContainerView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44.0, self.view.width, self.view.height - 44.0)];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        view.alpha = 0.0;
        view;
    });
    
    // Login container view
    self.loginContainerView = ({
        UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor clearColor];
        [self.diskQuotaAuthenticationContainerView addSubview:view];
        view;
    });
    
    // Titel label
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.1 * self.view.height, self.view.width, 100)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:58.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Disk Quota";
        [self.view addSubview:label];
        label;
    });
    
    // Username text field
    self.usernameTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.view.center.x, self.view.center.y - 0.5 * CGRectGetHeight(textField.bounds));
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.textAlignment = NSTextAlignmentCenter;
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
        
        [self.loginContainerView addSubview:textField];
        textField;
    });
    
    // Textfield separator view
    self.textFieldSeparatorView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 0.5)];
        view.backgroundColor = [UIColor whiteColor];
        view.center = self.view.center;
        [self.loginContainerView addSubview:view];
        view;
    });
    
    // Password text field
    self.passwordTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.view.center.x, self.view.center.y + 0.5 * CGRectGetHeight(textField.bounds));
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.textAlignment = NSTextAlignmentCenter;
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
        
        [self.loginContainerView addSubview:textField];
        textField;
    });
    
    // Login button
    self.loginButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(0.0, 0.0, 0.5 * self.view.width, 44.0);
        button.center = CGPointMake(self.view.center.x, 1.5 * self.view.center.y);
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [button setTitle:@"Login" forState:UIControlStateNormal];
        button.layer.cornerRadius = 10.0;
        button.layer.borderWidth = 0.75;
        [self.loginContainerView addSubview:button];
        button;
    });
}

#pragma mark UIButton Methods

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.loginButton) {
        [self.view endEditing:YES];
        [self adjustSubviewsWhileEditing:NO];
        [self authenticateWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
    }
}

#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!self.enteringCredentials) {
        [self adjustSubviewsWhileEditing:YES];
    }
    self.enteringCredentials = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.passwordTextField) {
        if(!self.enteringCredentials) {
            [self adjustSubviewsWhileEditing:NO];
        }
    }
    self.enteringCredentials = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if(textField == self.passwordTextField) {
        [self adjustSubviewsWhileEditing:NO];
        [self authenticateWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
    }
    return YES;
}

#pragma mark Authentication Animation

- (void)adjustSubviewsWhileEditing:(BOOL)editing
{
    CGPoint loginOffset = (editing)? CGPointMake(self.view.center.x, 0.5 * self.view.center.y) : self.view.center;
    CGFloat titleAlpha = (editing)? 0.0 : 1.0;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.loginContainerView.center = loginOffset;
        self.titleLabel.alpha = titleAlpha;
    } completion:nil];
}

#pragma mark Authentication

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UTCSSSHManager sharedSSHManager]connectWithUsername:username password:password completion:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(success) {
                [[UTCSSSHManager sharedSSHManager]disconnect];
                [UTCSAccountManager setUsername:username];
                [UTCSAccountManager setPassword:password];
            } else {
                [self.loginContainerView shake:3 withDelta:16.0];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

@end
