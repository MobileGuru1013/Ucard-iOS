//
//  NicknameViewController.h
//  Ucard
//
//  Created by Conner Wu on 15-4-13.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PasswordNicknameBaseViewController.h"

@interface NicknameViewController : PasswordNicknameBaseViewController

@property (nonatomic, strong) void (^submitBlock) (NSString *nickname, ActivityButton *button);

@end
