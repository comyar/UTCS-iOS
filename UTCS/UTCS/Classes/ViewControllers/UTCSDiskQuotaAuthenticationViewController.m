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

@interface UTCSDiskQuotaAuthenticationViewController ()
@property (nonatomic) UIView                    *loginContainerView;
@property (nonatomic) UITextField               *usernameTextField;
@property (nonatomic) UITextField               *passwordTextField;
@property (nonatomic) UTCSMenuButton            *menuButton;
@property (nonatomic) UIView                    *textFieldSeparatorView;
@property (nonatomic) UIButton                  *loginButton;
@end

@implementation UTCSDiskQuotaAuthenticationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor whiteColor];
    self.loginContainerView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.loginContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.loginContainerView];
    
    self.usernameTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.view.center.x, self.view.center.y - 0.5 * CGRectGetHeight(textField.bounds));
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.textColor = [UIColor blackColor];
        textField.tintColor = [UIColor darkGrayColor];
        textField.delegate = self;
        textField.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"CS Username"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor lightGrayColor]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
        textField.attributedPlaceholder = attributedPlaceholder;
        textField;
    });
    [self.loginContainerView addSubview:self.usernameTextField];
    
    self.textFieldSeparatorView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 0.5)];
        view.center = self.view.center;
        view.backgroundColor = [UIColor blackColor];
        view;
    });
    [self.loginContainerView addSubview:self.textFieldSeparatorView];
    
    self.passwordTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.view.center.x, self.view.center.y + 0.5 * CGRectGetHeight(textField.bounds));
        textField.textColor = [UIColor blackColor];
        textField.tintColor = [UIColor darkGrayColor];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.delegate = self;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.secureTextEntry = YES;
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"Password"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor lightGrayColor]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
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
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.cornerRadius = 10.0;
        [button setTitle:@"Login" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.loginContainerView addSubview:self.loginButton];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.loginContainerView.center = CGPointMake(self.view.center.x, 0.5 * self.view.center.y);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.passwordTextField) {
        [UIView animateWithDuration:0.3 animations:^{
            self.loginContainerView.center = self.view.center;
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.loginContainerView.center = self.view.center;
    }];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.loginButton) {
        BOOL success = [[UTCSSSHManager sharedSSHAuthHandler]connectWithUsername:self.usernameTextField.text
                                                                        password:self.passwordTextField.text];
        if(success) {
            NSString *result = [[UTCSSSHManager sharedSSHAuthHandler]executeCommand:@"ls"];
            NSLog(@"%@", result);
            
            // Store in keychain
            // pop view controller
        } else {
            // shake window
            [self.loginContainerView shake:3 withDelta:16.0];
        }
    }
}

@end
