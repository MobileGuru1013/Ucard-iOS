//
//  CommonBackViewController.h
//  Teacher
//
//  Created by WuLeilei on 15/1/17.
//  Copyright (c) 2015年 WuLeilei. All rights reserved.
//

#import "BaseViewController.h"

@interface CommonBackViewController : BaseViewController

@property (nonatomic, strong) void (^goBackBlock) ();
- (void)setRightButton:(UIImage *)image target:(id)target selector:(SEL)selector;
- (void)setRightButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
- (void)goBack;

@end
