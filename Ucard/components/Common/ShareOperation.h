//
//  ShareOperation.h
//  Ucard
//
//  Created by Conner Wu on 15/5/19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#define kShareWeiboNotification @"ShareWeiboNotification"

typedef void (^ShareCompletedBlock) (BOOL succ);

typedef enum {
    ShareTypeFacebook = 0,
    ShareTypeWeixin = 1
} ShareType;

@interface ShareOperation : NSObject <WXApiDelegate>

@property (nonatomic, strong) NSString *weiboToken;
@property (nonatomic, assign) UIViewController *viewController;

+ (instancetype)shareInstance;
- (void)showShareView:(UIButton *)button imagePath:(NSString *)imagePath image:(UIImage *)image complete:(ShareCompletedBlock)complete;

@end
