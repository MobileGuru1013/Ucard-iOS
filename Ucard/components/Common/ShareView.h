//
//  ShareView.h
//  Ucard
//
//  Created by WuLeilei on 15/5/19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

@property (nonatomic, strong) void (^closeBlock) ();
@property (nonatomic, strong) void (^shareBlock) (NSInteger index);

@end
