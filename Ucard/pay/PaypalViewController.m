//
//  PaypalViewController.m
//  Ucard
//
//  Created by Conner Wu on 15/5/5.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PaypalViewController.h"
#import "UIWebView+AFNetworking.h"

@interface PaypalViewController () <UIWebViewDelegate>
{
    NSString *_url;
    UIActivityIndicatorView *_indicatorView;
}
@end

@implementation PaypalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRightButton];
    self.title = NSLocalizedString(@"localized218",nil);
    
    _webView.frame = self.view.bounds;
    _webView.delegate = self;
    _webView.alpha = 0.0;
    [self.view addSubview:_webView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    _indicatorView.center = self.view.center;
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_indicatorView startAnimating];
    [self.view addSubview:_indicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    [[Singleton shareInstance] stopLoading];
    
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[Singleton shareInstance] startLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_indicatorView) {
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
    
    [[Singleton shareInstance] stopLoading];
    
    if (_webView.alpha == 0.0) {
        [UIWebView animateWithDuration:0.35
                            animations:^{
                                _webView.alpha = 1.0;
                            }];
    }
    
    if (_url) {
        if ([_url rangeOfString:@"paypal-return-url.php"].location != NSNotFound) {
            if (self.finishedBlock) {
                self.finishedBlock();
            }
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[Singleton shareInstance] stopLoading];
    NSLog(@"%@", error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    _url = request.URL.absoluteString;
    NSLog(@"%@", _url);
    
    return YES;
}

@end
