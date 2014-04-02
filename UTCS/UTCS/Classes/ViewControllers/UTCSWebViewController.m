//
//  UTCSWebViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSWebViewController.h"
#import "UIView+CZPositioning.h"


@interface UTCSWebViewController ()
@property (nonatomic) UINavigationBar *navigationBar;
@property (nonatomic) UIWebView *webView;
@end

@implementation UTCSWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.webView = [UIWebView new];
        self.webView.scalesPageToFit = YES;
        [self.view addSubview:self.webView];
        
        self.navigationBar = [UINavigationBar new];
        self.navigationBar.backgroundColor = [UIColor darkGrayColor];
        [self.view addSubview:self.navigationBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.frame = CGRectMake(0.0, 0.0, self.view.width, 44);
    self.webView.frame = CGRectMake(0.0, 44, self.view.width, self.view.height - self.navigationBar.height);
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

@end
