//
//  SettingsViewController.h
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommonBackViewController.h"

@interface SettingsViewController : CommonBackViewController
@property (nonatomic, strong) void (^editProfileBlock) (UIButton *button);
@end