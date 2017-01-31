//
//  Singleton.h
//
//
//  Created by WuLeilei.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftCardModel.h"
#import "UserInfoModel.h"

@class MBProgressHUD;

@interface Singleton : NSObject
{
    NSUInteger _loadingCount;
}

@property (nonatomic, strong) MBProgressHUD *loadingView;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) DraftCardModel *cardModel;
@property (nonatomic, strong) UserInfoModel *user;

+ (instancetype)shareInstance;
- (void)destory;
- (void)startLoading;
- (void)startLoadingInView:(UIView *)view;
- (void)stopLoading;

@end