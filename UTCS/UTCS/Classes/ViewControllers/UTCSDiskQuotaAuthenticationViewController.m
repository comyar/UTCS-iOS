//
//  UTCSDiskQuotaAuthenticationViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDiskQuotaAuthenticationViewController.h"
#import "UTCSMenuButton.h"
#import "UIView+CZPositioning.h"
#import "UTCSSSHManager.h"
#import "UIView+Shake.h"
#import "UTCSAccountManager.h"
#import "MBProgressHUD.h"
#import "UIColor+UTCSColors.h"

@interface UTCSDiskQuotaAuthenticationViewController ()
@property (nonatomic) UIView                    *loginContainerView;
@property (nonatomic) UITextField               *usernameTextField;
@property (nonatomic) UITextField               *passwordTextField;
@property (nonatomic) UTCSMenuButton            *menuButton;
@property (nonatomic) UIView                    *textFieldSeparatorView;
@property (nonatomic) UIButton                  *loginButton;
@property (nonatomic) UILabel                   *titleLabel;
@end

@implementation UTCSDiskQuotaAuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginContainerView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.loginContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.loginContainerView];
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.1 * self.view.height, self.view.width, 100)];
        label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:62];
        label.textColor = [UIColor utcsDarkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Disk Quota";
        label;
    });
    [self.view addSubview:self.titleLabel];
    
    
    self.usernameTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.view.center.x, self.view.center.y - 0.5 * CGRectGetHeight(textField.bounds));
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.textColor = [UIColor blackColor];
        textField.tintColor = [UIColor darkGrayColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyNext;
        textField.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"username"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor utcsLightGrayColor]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
        textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        textField.attributedPlaceholder = attributedPlaceholder;
        textField;
    });
    [self.loginContainerView addSubview:self.usernameTextField];
    
    self.textFieldSeparatorView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 0.5)];
        view.backgroundColor = [UIColor utcsBurntOrangeColor];
        view.center = self.view.center;
        view.alpha = 0.5;
        view;
    });
    [self.loginContainerView addSubview:self.textFieldSeparatorView];
    
    self.passwordTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.view.center.x, self.view.center.y + 0.5 * CGRectGetHeight(textField.bounds));
        textField.textColor = [UIColor blackColor];
        textField.tintColor = [UIColor darkGrayColor];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.secureTextEntry = YES;
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"password"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor utcsLightGrayColor]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
        textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        textField.attributedPlaceholder = attributedPlaceholder;
        textField;
    });
    [self.loginContainerView addSubview:self.passwordTextField];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
    self.menuButton.lineColor = [UIColor blackColor];
    [self.view addSubview:self.menuButton];
    
    self.loginButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0.0, 0.0, 0.5 * self.view.width, 44.0);
        button.center = CGPointMake(self.view.center.x, 1.5 * self.view.center.y);
        button.layer.borderWidth = 0.75;
        button.layer.borderColor = [UIColor utcsDarkGrayColor].CGColor;
        button.layer.cornerRadius = 10.0;
        [button setTitle:@"Login" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor utcsDarkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.loginContainerView addSubview:self.loginButton];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.loginContainerView.center = CGPointMake(self.view.center.x, 0.5 * self.view.center.y);
        self.titleLabel.alpha = 0.0;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.passwordTextField) {
        [UIView animateWithDuration:0.3 animations:^{
            self.loginContainerView.center = self.view.center;
            self.titleLabel.alpha = 1.0;
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if(textField == self.passwordTextField) {
        // auth
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.loginContainerView.center = self.view.center;
        self.titleLabel.alpha = 1.0;
    }];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.loginButton) {
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.loginContainerView.center = self.view.center;
        }];
        NSString *username = self.usernameTextField.text;
        NSString *password = self.passwordTextField.text;
        
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
}

@end
