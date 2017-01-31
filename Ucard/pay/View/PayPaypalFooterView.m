//
//  PayPaypalFooterView.m
//  Ucard
//
//  Created by WuLeilei on 15/5/27.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PayPaypalFooterView.h"

@interface PayPaypalFooterView () <UIWebViewDelegate>

@end

@implementation PayPaypalFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 60)];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        [_webView setOpaque:NO];
        [self.contentView addSubview:_webView];
    }
    return self;
}

- (void)loadPath:(NSString *)path recordId:(NSString *)recordId
{
    NSString *string = [NSString stringWithFormat:@"%@%@?record_id=%@", kApiURL, path, recordId];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@", url);
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[Singleton shareInstance] startLoadingInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[Singleton shareInstance] stopLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[Singleton shareInstance] stopLoading];
    NSLog(@"%@", error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"%@", url);
    if ([url rangeOfString:@"paypal.com"].location != NSNotFound) {
        if (self.submitBlock) {
            self.submitBlock();
        }
    }
    
    return YES;
}

- (void)submit
{
    [super submit];
}

@end
