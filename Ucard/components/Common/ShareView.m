//
//  ShareView.m
//  Ucard
//
//  Created by WuLeilei on 15/5/19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ShareView.h"
#import "UIView+Frame.h"

@implementation ShareView

- (id)init
{
    NSArray *array = @[@{@"icon": @"signin_facebook", @"text": NSLocalizedString(@"localized138", nil)},
                       @{@"icon": @"share-weixin-timeline", @"text": NSLocalizedString(@"localized139", nil)}];
    CGFloat height = 65 + (54 + 50) + 30;
    CGRect frame = CGRectMake(0, kScreenHeight + height, kScreenWidth, height);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.980 green:0.980 blue:0.980 alpha:1];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(0, 0, 60, 60);
        [closeButton setImage:[UIImage imageNamed:@"share-close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(closeButton.frame))];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = NSLocalizedString(@"localized140", nil);
        [self addSubview:title];
        
        CGFloat marginH = (kScreenWidth - array.count * 54) / (array.count + 1);
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(marginH * (idx + 1) + 54 * idx, CGRectGetMaxY(closeButton.frame) + 10, 54, 54);
            button.tag = idx;
            [button setImage:[UIImage imageNamed:[obj objectForKey:@"icon"]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(button.frame) - 30, CGRectGetMaxY(button.frame), CGRectGetWidth(button.frame) + 30 * 2, 50)];
            label.text = [obj objectForKey:@"text"];
            label.textColor = kTextGrayColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            [self addSubview:label];
        }];
    }
    return self;
}

- (void)close
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)share:(UIButton *)button
{
    if (self.shareBlock) {
        self.shareBlock(button.tag);
    }
}

@end
