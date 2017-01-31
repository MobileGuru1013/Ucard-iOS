//
//  FrontBgView.h
//  Ucard
//
//  Created by WuLeilei on 15/4/9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrontBgView : UIView

@property (nonatomic, strong) void (^refreshImageBlock) ();
- (void)setContent;
- (void)handleFrame:(UIButton *)button;
@end
