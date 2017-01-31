//
//  Singleton.m
//
//
//  Created by WuLeilei.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import "Singleton.h"
#import "MBProgressHUD.h"

@implementation Singleton

// 获取单例
+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
	return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)destory
{
    _user = nil;
    _uid = nil;
    _cardModel = nil;
}

#pragma mark Loading

- (void)startLoading
{
    [self startLoadingInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (void)startLoadingInView:(UIView *)view
{
    _loadingCount++;
    
    if (_loadingCount == 1) {
        _loadingView = [[MBProgressHUD alloc] initWithView:view];
        _loadingView.color = [UIColor colorWithWhite:1.0 alpha:0.8];
        _loadingView.labelColor = [UIColor blackColor];
        [_loadingView show:YES];
    } else {
        [_loadingView removeFromSuperview];
    }
    [view addSubview:_loadingView];
}

- (void)stopLoading
{
    [self delayStopLoading];
}

- (void)delayStopLoading
{
    if (_loadingCount > 0) {
        _loadingCount--;
    }
    
    // 当没有请求web的时候才移除loading
    if (_loadingCount == 0) {
        [_loadingView hide:YES];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
        
        // 网络加载标志停止转动
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

@end
