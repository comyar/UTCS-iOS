//
//  UTCSWebViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

// -----
// @name View Controllers
// -----

#import "UTCSWebViewController.h"

// -----
// @name Views
// -----

#import "UTCSButton.h"

// -----
// @name Categories
// -----

#import "UIColor+UTCSColors.h"
#import "UIView+CZPositioning.h"


#pragma mark - Constants

// Height of the top control view
static const CGFloat topControlViewHeight = 44.0;


#pragma mark - UTCSWebViewController Class Extension

@interface UTCSWebViewController ()

//
@property (nonatomic) UIWebView     *webView;

//
@property (nonatomic) NSMutableData *data;

//
@property (nonatomic) UTCSButton    *closeButton;

//
@property (nonatomic) CAShapeLayer  *progressLayer;

//
@property (nonatomic) UIView        *topControlView;

//
@property (nonatomic) NSProgress    *progress;

//
@property (nonatomic) NSURLResponse *response;

@end


#pragma mark - UTCSWebViewController Implementation

@implementation UTCSWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Web view
    self.webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0, topControlViewHeight, self.view.width, self.view.height - topControlViewHeight)];
        webView.backgroundColor = [UIColor utcsDarkGrayColor];
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        webView;
    });
    
    // Top control view
    self.topControlView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, topControlViewHeight)];
        view.backgroundColor = [UIColor utcsDarkGrayColor];
        
        self.closeButton = ({
            UTCSButton *button = [[UTCSButton alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *closeImage = [[UIImage imageNamed:@"close"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:closeImage];
            imageView.tintColor = [UIColor whiteColor];
            imageView.frame = CGRectMake(0, 0, 20, 20);
            imageView.center = button.center;
            [button addSubview:imageView];
            
            [view addSubview:button];
            button;
        });
        
        [self.view addSubview:view];
        view;
    });
    
    self.progressLayer = ({
        CAShapeLayer *layer = [CAShapeLayer new];
        layer.strokeColor = [UIColor utcsYellowColor].CGColor;
        layer.lineWidth = 1.0;
        layer.path = ({
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0.0, self.topControlView.height - 1.0)];
            [path addLineToPoint:CGPointMake(self.topControlView.width, self.topControlView.height - 1.0)];
            path.CGPath;
        });
        layer;
    });
    
    [self.topControlView.layer addSublayer:self.progressLayer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startConnectionWithURL:self.url];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark Using a UTCSWebViewController

- (void)startConnectionWithURL:(NSURL *)url
{
    if(!url) {
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if(button == self.closeButton) {
        [self.delegate webViewControllerDidRequestDismissal:self];
    }
}

#pragma mark NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    if([self.response expectedContentLength] != NSURLResponseUnknownLength) {
        self.data       = [[NSMutableData alloc]initWithCapacity:(NSUInteger)self.response.expectedContentLength];
        self.progress   = [NSProgress progressWithTotalUnitCount:self.response.expectedContentLength];
    } else {
        self.data       = [NSMutableData new];
        self.progress   = [NSProgress progressWithTotalUnitCount:100];
    }
    self.progressLayer.strokeEnd = self.progress.fractionCompleted;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(self.response.expectedContentLength != NSURLResponseUnknownLength) {
        self.progress.completedUnitCount += [data length];
    } else {
        self.progress.completedUnitCount = 33;
    }
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.webView loadData:self.data
                  MIMEType:self.response.MIMEType
          textEncodingName:self.response.textEncodingName
                   baseURL:self.response.URL];
    self.progressLayer.strokeEnd = 1.0;
}

@end
