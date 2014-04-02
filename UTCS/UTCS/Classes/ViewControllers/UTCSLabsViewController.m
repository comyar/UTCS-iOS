//
//  UTCSLabsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsViewController.h"
#import "UTCSMenuButton.h"
#import "UIImage+ImageEffects.h"
#import "MBProgressHUD.h"
#import "UTCSSSHManager.h"


@interface UTCSLabsViewController ()
@property (nonatomic) UIImageView               *backgroundImageView;
@property (nonatomic) UTCSMenuButton            *menuButton;
@property (nonatomic) UITextField               *usernameTextField;
@property (nonatomic) UITextField               *passwordTextField;
@property (nonatomic) UIView                    *textFieldSeparatorView;
@property (nonatomic) UIButton                  *loginButton;
@end

@implementation UTCSLabsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.backgroundImageView.image = [[UIImage imageNamed:@"menuBackground"]applyDarkEffect];
    [self.view addSubview:self.backgroundImageView];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
    [self.view addSubview:self.menuButton];
    
    self.usernameTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.view.center.x, self.view.center.y - 0.5 * CGRectGetHeight(textField.bounds));
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.textColor = [UIColor whiteColor];
        textField.tintColor = [UIColor lightGrayColor];
        textField.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"CS Username"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor colorWithWhite:1.0 alpha:0.5]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
        textField.attributedPlaceholder = attributedPlaceholder;
        textField;
    });
    [self.view addSubview:self.usernameTextField];
    
    self.textFieldSeparatorView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 0.5)];
        view.center = self.view.center;
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.view addSubview:self.textFieldSeparatorView];
    
    self.passwordTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.8 * CGRectGetWidth(self.view.bounds), 44)];
        textField.center = CGPointMake(self.view.center.x, self.view.center.y + 0.5 * CGRectGetHeight(textField.bounds));
        textField.textColor = [UIColor whiteColor];
        textField.tintColor = [UIColor lightGrayColor];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.secureTextEntry = YES;
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"Password"];
        [attributedPlaceholder addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor colorWithWhite:1.0 alpha:0.5]
                                      range:NSMakeRange(0, [attributedPlaceholder length])];
        textField.attributedPlaceholder = attributedPlaceholder;
        textField;
    });
    [self.view addSubview:self.passwordTextField];
    
    self.loginButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0.0, 0.0, 0.75 * CGRectGetWidth(self.view.bounds), 44);
        button.center = CGPointMake(self.view.center.x, 1.5 * self.view.center.y);
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.0;
        button.layer.cornerRadius = 6.0;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Login" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.loginButton];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.loginButton) {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [[UTCSSSHManager sharedSSHAuthHandler]connectWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }];
        });
    }
}

@end
