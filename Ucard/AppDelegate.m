//
//  AppDelegate.m
//  Ucard
//
//  Created by Conner Wu on 15-3-19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "SignupViewController.h"
#import "SigninViewController.h"
#import "AccountViewController.h"
#import "CommunityViewController.h"
#import "PostcardViewController.h"
#import "SVProgressHUD.h"
#import "ShareOperation.h"
#import "ConfigModel.h"

@interface AppDelegate () <WeiboSDKDelegate>
{
    UITabBarController *_tabBarController;
    UIImageView *_redImageView;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([ConfigModel isLaunched]) {
        [self setRootSignin];
    } else {
       [self setRootWelcome];
    }

//    [self setRootSignup];
    
    [self.window makeKeyAndVisible];
    
    // 新浪微博
    [WeiboSDK registerApp:kWeiboAppKey];
    
    // 微信
    [WXApi registerApp:kWeixinAppKey];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    

    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([sourceApplication isEqualToString:@"com.facebook.Facebook"] || [sourceApplication isEqualToString:@"com.apple.mobilesafari"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    } else if ([sourceApplication isEqualToString:@"com.sina.weibo"] || [sourceApplication isEqualToString:@"com.sina.weibohd"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:[ShareOperation shareInstance]];
    }
    
    // alipay
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                         }];
        
        [[AlipaySDK defaultService] processAuthResult:url
                                      standbyCallback:^(NSDictionary *resultDic) {
                                          NSLog(@"result = %@",resultDic);
                                      }];
    }
    
    return YES;
}

// 独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url scheme] isEqualToString:kAppScheme] == YES) { // weibo
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else if ([[url scheme] isEqualToString:kWeixinAppKey] == YES) { // weixin
        return [WXApi handleOpenURL:url delegate:[ShareOperation shareInstance]];;
    }
    return YES;
}

+ (instancetype)shareDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma 新浪微博

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        BOOL succ;
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            succ = YES;
        } else {
            succ = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"%@", response.userInfo]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kShareWeiboNotification object:[NSNumber numberWithBool:succ]];
    } else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        // 登录
        [ShareOperation shareInstance].weiboToken = [(WBAuthorizeResponse *)response accessToken];
        NSDictionary *dic = response.userInfo;
        if ([dic.allKeys containsObject:@"uid"]) {
            [[Singleton shareInstance] startLoadingInView:self.window.rootViewController.view];
            
            NSString *uid = [dic objectForKey:@"uid"];
            NSString *access_token = [dic objectForKey:@"access_token"];
            [WBHttpRequest requestForUserProfile:uid
                                 withAccessToken:access_token
                              andOtherProperties:nil
                                           queue:nil
                           withCompletionHandler:^(WBHttpRequest *httpRequest, WeiboUser *result, NSError *error) {
                               [[Singleton shareInstance] stopLoading];
                               NSLog(@"%@", result);
                               
                               // 第三方注册
                               SigninBaseViewController *viewController = (SigninBaseViewController *)self.window.rootViewController;
                               if ([viewController isKindOfClass:[SigninBaseViewController class]]) {
                                   NSString *name = result.name ? result.name : @" ";
                                   [viewController checkSNS:@"weibo" uid:uid nickname:name andEmail:@"" andImagePath:result.profileImageUrl];
                               }
                           }];
        }
    }
}

#pragma mark 跳转
- (void)setRootWelcome
{
    WelcomeViewController *viewController = [[WelcomeViewController alloc] init];
    self.window.rootViewController = viewController;
}

- (void)setRootSignup
{
    [ConfigModel setLaunched];
    
    SignupViewController *viewController = [[SignupViewController alloc] init];
    self.window.rootViewController = viewController;
    
}

- (void)setRootSignin
{
    [ConfigModel setLaunched];
    
    SigninViewController *viewController = [[SigninViewController alloc] init];
    self.window.rootViewController = viewController;
    
}

- (void)setRootHome
{
   
    CommunityViewController *community = [[CommunityViewController alloc] init];
    community.title = NSLocalizedString(@"localized024", nil);
    
    UINavigationController *communityNav = [[UINavigationController alloc] initWithRootViewController:community];
    communityNav.tabBarItem.image = [UIImage imageNamed:@"public-tabbar-community"];
    
    
    UINavigationController *postcardNav = [self cardNav];
    
    AccountViewController *account = [[AccountViewController alloc] init];
    account.title = NSLocalizedString(@"localized026", nil);
    
    UINavigationController *accountNav = [[UINavigationController alloc] initWithRootViewController:account];
    accountNav.tabBarItem.image = [UIImage imageNamed:@"public-tabbar-account"];
    UIImage *selectBackground = [UIImage imageNamed:@"select_tabbar"];
    [[UITabBar appearance] setSelectionIndicatorImage:selectBackground];
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[communityNav, postcardNav, accountNav];
    _tabBarController.delegate = self;

    _tabBarController.selectedIndex = 1;
    
    [self setRootToViewController:_tabBarController];
    
    if (![ConfigModel isReceived]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setReceived) name:kIsReceivedTabNotification object:nil];
        
        CGFloat tabWidth = kScreenWidth / 3.0;
        _redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - tabWidth / 2.0 + 13, 5, 10.0, 10.0)];
        _redImageView.backgroundColor = kRedColor;
        _redImageView.layer.cornerRadius = CGRectGetWidth(_redImageView.frame) / 2.0;
        [_tabBarController.tabBar addSubview:_redImageView];
    }
}

- (void)setReceived
{
    [ConfigModel setReceived];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kIsReceivedTabNotification object:nil];
    
    [_redImageView removeFromSuperview];
    _redImageView = nil;
}

- (void)setRootToViewController:(UIViewController *)viewController
{
    viewController.view.alpha = 0;
    [self.window.rootViewController.view addSubview:viewController.view];
    [UIView animateWithDuration:0.35
                     animations:^{
                         viewController.view.alpha = 1;
                     } completion:^(BOOL finished) {
                         [viewController.view removeFromSuperview];
                         self.window.rootViewController = viewController;
                     }];
}

- (void)reloadCardViewController

{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_tabBarController.viewControllers];
    [array replaceObjectAtIndex:1 withObject:[self cardNav]];
    [_tabBarController setViewControllers:array];
}

- (UINavigationController *)cardNav

{
    PostcardViewController *postcard = [[PostcardViewController alloc] init];
    postcard.title = NSLocalizedString(@"localized025", nil);;
    
    UINavigationController *postcardNav = [[UINavigationController alloc] initWithRootViewController:postcard];
    postcardNav.tabBarItem.image = [UIImage imageNamed:@"public-tabbar-postcard"];
    return postcardNav;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

}
@end
