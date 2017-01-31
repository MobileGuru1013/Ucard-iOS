//
//  AppDelegate.h
//  Ucard
//
//  Created by Conner Wu on 15-3-19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)shareDelegate;
- (void)setRootHome;
- (void)setRootSignup;
- (void)setRootSignin;
- (void)reloadCardViewController;

@end

