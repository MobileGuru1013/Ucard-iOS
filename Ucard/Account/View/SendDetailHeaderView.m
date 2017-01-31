//
//  SendDetailHeaderView.m
//  Ucard
//
//  Created by Conner Wu on 15/5/9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SendDetailHeaderView.h"

@interface SendDetailHeaderView ()
{
    UIButton *_flipButton;
    UIView *_mainBgView;
    UIImageView *_backView;
    UIImageView *_frontView;
}
@end

@implementation SendDetailHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setContent:(SendDetailModel *)cardModel
{
    if (!cardModel) {
        return;
    }

    // 正反面父视图
    _mainBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kCardHeight * kScreenWidth / kCardWidth)];
    _mainBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    _mainBgView.backgroundColor = [UIColor redColor];
    _mainBgView.layer.shadowOpacity = 0.7;
    _mainBgView.layer.shadowOffset = CGSizeMake(0, 0);
    _mainBgView.layer.shadowRadius = 2.0;
    _mainBgView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_mainBgView];
    
    _backView = [[UIImageView alloc] initWithFrame:_mainBgView.bounds];
    [Constants setImageView:_backView path:cardModel.postcard_back];
    [_mainBgView addSubview:_backView];
    
    _frontView = [[UIImageView alloc] initWithFrame:_mainBgView.bounds];
    [Constants setImageView:_frontView path:cardModel.postcard_head];
    [_mainBgView addSubview:_frontView];
}

+ (CGFloat)height
{
    return kCardHeight * kScreenWidth / kCardWidth + 20;
}

- (void)flip
{
    _flipButton.enabled = NO;
    
    
    
    // 翻转
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.35;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    
    NSUInteger front = [_mainBgView.subviews indexOfObject:_frontView];
    NSUInteger back = [_mainBgView.subviews indexOfObject:_backView];
    [_mainBgView exchangeSubviewAtIndex:front withSubviewAtIndex:back];
    
    [_mainBgView.layer addAnimation:animation forKey:@"animation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _flipButton.enabled = YES;;
}

@end
