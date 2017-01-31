//
//  BackBgView.h
//  Ucard
//
//  Created by WuLeilei on 15/4/9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackBgView : UIView

@property (nonatomic, strong) void (^toolBlock) (NSUInteger index);

- (void)setContent;

@end
