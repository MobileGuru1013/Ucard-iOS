//
//  WebViewViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/14.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadHTML:(NSString *)name

{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    NSURL *url = [NSURL URLWithString:path];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    
}

@end
