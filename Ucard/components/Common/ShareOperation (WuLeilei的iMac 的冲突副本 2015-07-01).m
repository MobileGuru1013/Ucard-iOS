//
//  ShareOperation.m
//  Ucard
//
//  Created by Conner Wu on 15/5/19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ShareOperation.h"
#import "WeiboSDK.h"
#import "ShareView.h"
#import "SVProgressHUD.h"
#import "UIView+Frame.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "UIImage+Resizing.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"

@interface ShareOperation () <FBSDKSharingDelegate>
{
    NSString *_imagePath;
    ShareCompletedBlock _complete;
    ShareView *_shareView;
    UIView *_shareBgView;
    UIImage *_image;
}
@end

@implementation ShareOperation

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
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiboCallback:) name:kShareWeiboNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShareWeiboNotification object:nil];
}

- (void)showShareView:(UIButton *)button imagePath:(NSString *)imagePath image:(UIImage *)image complete:(ShareCompletedBlock)complete
{
    _imagePath = imagePath;
    _complete = complete;
    _image = image;
    
    __weak typeof(self) weakself = self;
    if (![[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:[Constants getSmallImageURLString:imagePath]]]) {
        [[Singleton shareInstance] startLoading];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[Constants getSmallImageURLString:imagePath]] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            _image = image;
            [[Singleton shareInstance] stopLoading];
            
            [weakself showShare:button];
        }];
    } else {
        [self showShare:button];
    }
}

// 分享
- (void)showShare:(UIButton *)button
{
    button.enabled = NO;
    
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    _shareBgView = [[UIView alloc] initWithFrame:superView.bounds];
    _shareBgView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    _shareBgView.alpha = 0;
    [superView addSubview:_shareBgView];
    
    __weak typeof(self) weakself = self;
    _shareView = [[ShareView alloc] init];
    _shareView.closeBlock = ^() {
        [weakself closeShare];
    };
    _shareView.shareBlock = ^(NSInteger index) {
        [weakself shareTo:index];
    };
    [superView addSubview:_shareView];
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         _shareBgView.alpha = 1;
                         [_shareView setFrameOriginY:kScreenHeight - CGRectGetHeight(_shareView.frame)];
                     } completion:^(BOOL finished) {
                         button.enabled = YES;
                     }];
}

- (void)closeShare
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         _shareBgView.alpha = 0;
                         [_shareView setFrameOriginY:kScreenHeight];
                     } completion:^(BOOL finished) {
                         [_shareBgView removeFromSuperview];
                         _shareBgView = nil;
                         
                         [_shareView removeFromSuperview];
                         _shareView = nil;
                     }];
}

- (void)shareTo:(ShareType)type
{
    switch (type) {
        case ShareTypeWeixin:
            [self shareToWeixin];
            break;
            
        case ShareTypeFacebook:
            [self shareToFacebook];
            break;
            
        default:
            break;
    }
}

#pragma mark 分享到微信

- (void)shareToWeixin
{
    NSData *data;
    if (UIImagePNGRepresentation(_image) == nil) {
        data = UIImageJPEGRepresentation(_image, 1.0);
    } else {
        data = UIImagePNGRepresentation(_image);
    }
    if (!data) {
        data = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder"]);
    }
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.url = kAppURL;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = NSLocalizedString(@"localized136", nil);
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
    [self closeShare];
}

// 微信回调
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == 0) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized137", nil)];
        } else {
            [SVProgressHUD showErrorWithStatus:resp.errStr];
        }
    }
}

#pragma mark 分享到FB

- (void)shareToFacebook
{
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = _image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    [FBSDKShareDialog showFromViewController:_viewController
                                 withContent:content
                                    delegate:self];
    
    [self closeShare];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized137", nil)];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:error.description];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"Cancel");
}

@end
