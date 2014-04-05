//
//  UTCSDiskQuotaAuthenticationViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// View Controllers
#import "UTCSDiskQuotaAuthenticationViewController.h"

// Views
#import "MBProgressHUD.h"
#import "UTCSMenuButton.h"


// Categories
#import "UIView+Shake.h"
#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"

// Models
#import "UTCSSSHManager.h"
#import "UTCSAccountManager.h"


#pragma mark - UTCSDiskQuotaAuthenticationViewController Class Extension

@interface UTCSDiskQuotaAuthenticationViewController ()

// Label displaying the title of the view controller
@property (nonatomic) UILabel                   *titleLabel;

// Button used to display the menu view controller
@property (nonatomic) UTCSMenuButton            *menuButton;

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


#pragma mark - UTCSDiskQuotaAuthenticationViewController Implementation

@implementation UTCSDiskQuotaAuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Login container view
    self.loginContainerView = ({
        UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        view;
    });
    
    // Titel label
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.1 * self.view.height, self.view.width, 100)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:62];
        label.textColor = [UIColor utcsDarkGrayColor];
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
        textField.tintColor = [UIColor darkGrayColor];
        textField.textColor = [UIColor blackColor];
        textField.returnKeyType = UIReturnKeyNext;
        textField.delegate = self;
        
        // Placeholder
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"username"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:[UIColor utcsLightGrayColor]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
        textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        textField.attributedPlaceholder = attributedPlaceholder;
        
        [self.view addSubview:textField];
        textField;
    });
    
    // Textfield separator view
    self.textFieldSeparatorView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 0.5)];
        view.backgroundColor = [UIColor utcsBurntOrangeColor];
        view.center = self.view.center;
        view.alpha = 0.5;
        [self.view addSubview:view];
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
        textField.tintColor = [UIColor darkGrayColor];
        textField.textColor = [UIColor blackColor];
        textField.returnKeyType = UIReturnKeyNext;
        textField.secureTextEntry = YES;
        textField.delegate = self;
        
        // Placeholder
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"password"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:[UIColor utcsLightGrayColor]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
        textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        textField.attributedPlaceholder = attributedPlaceholder;
        
        [self.view addSubview:textField];
        textField;
    });
    
    // Menu Button
    self.menuButton = ({
        UTCSMenuButton *button = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
        button.lineColor = [UIColor blackColor];
        [self.view addSubview:button];
        button;
    });
    
    // Login button
    self.loginButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor utcsDarkGrayColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(0.0, 0.0, 0.5 * self.view.width, 44.0);
        button.center = CGPointMake(self.view.center.x, 1.5 * self.view.center.y);
        button.layer.borderColor = [UIColor utcsDarkGrayColor].CGColor;
        [button setTitle:@"Login" forState:UIControlStateNormal];
        button.layer.cornerRadius = 10.0;
        button.layer.borderWidth = 0.75;
        [self.view addSubview:button];
        button;
    });

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self adjustSubviewsWhileEditing:NO];
}

#pragma mark UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self adjustSubviewsWhileEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.passwordTextField) {
        [self adjustSubviewsWhileEditing:NO];
    }
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

#pragma mark UIButton Methods

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.loginButton) {
        [self.view endEditing:YES];
        [self adjustSubviewsWhileEditing:NO];
        [self authenticateWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
    }
}

#pragma mark Animations

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
                [self.delegate didAuthenticate];
            } else {
                [self.loginContainerView shake:3 withDelta:16.0];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

@end
