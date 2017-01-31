//
//  ConfigModel.h
//  Ucard
//
//  Created by Conner Wu on 15/5/21.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIsReceivedTabNotification @"kIsReceivedTabNotification"
#define kIsReceivedAccountNotification @"kIsReceivedAccountNotification"

@interface ConfigModel : NSObject

+ (BOOL)isLaunched;
+ (BOOL)setLaunched;
+ (BOOL)isReceived;
+ (BOOL)setReceived;

@end
