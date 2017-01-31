//
//  CardNewFrontWrapView.m
//  Ucard
//
//  Created by WuLeilei on 15/5/17.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CardNewFrontWrapView.h"
#import "CardNewFrontView.h"

@interface CardNewFrontWrapView ()
{
    CardNewFrontView *_frontView;
    UIImageView *_frameImageView;
    UILabel *captionLb;
}
@end

@implementation CardNewFrontWrapView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _frontView = [[CardNewFrontView alloc] initWithFrame:self.bounds];
        [self addSubview:_frontView];
        
        // 边框
        _frameImageView = [[UIImageView alloc] initWithFrame:self.frame];
        _frameImageView.alpha = 0;
        [self addSubview:_frameImageView];
        
        CGFloat frameWidth = 20;
        
        // 左边
        UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, CGRectGetHeight(_frameImageView.frame))];
        left.backgroundColor = [UIColor whiteColor];
        [_frameImageView addSubview:left];
        
        // 上边
        UIImageView *top = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_frameImageView.frame), frameWidth)];
        top.backgroundColor = [UIColor whiteColor];
        [_frameImageView addSubview:top];
        
        // 右边
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_frameImageView.frame) - frameWidth, 0, frameWidth, CGRectGetHeight(_frameImageView.frame))];
        right.backgroundColor = [UIColor whiteColor];
        [_frameImageView addSubview:right];
        
        // 下边
        UIImageView *bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_frameImageView.frame) - frameWidth, CGRectGetWidth(_frameImageView.frame), frameWidth)];
        bottom.backgroundColor = [UIColor whiteColor];
        
        
        captionLb = [[UILabel alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(_frameImageView.frame)- frameWidth, frameWidth)];
        captionLb.font=[UIFont systemFontOfSize:10];
        captionLb.textAlignment=NSTextAlignmentRight;
         [bottom addSubview:captionLb];
        [_frameImageView addSubview:bottom];
    }
    return self;
}

- (void)setContent:(BOOL)newImage
{
    [_frontView setContent:newImage];
    NSString *captionText = [Singleton shareInstance].cardModel.captionText;
    captionLb.text = captionText;
    if ([Singleton shareInstance].cardModel.frame != _frameImageView.alpha) {
        [UIView animateWithDuration:0.35
                         animations:^{
                             _frameImageView.alpha = [Singleton shareInstance].cardModel.frame;
                         }];
    }
}

- (void)clipImageView
{
    [_frontView clipImageView];
}
- (void)resetScrollView
{
    [_frontView resetScrollView];
}
@end
