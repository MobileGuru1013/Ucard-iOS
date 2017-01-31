//
//  ReceiveDetailHeaderView.m
//  Ucard
//
//  Created by Conner Wu on 15/5/9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ReceiveDetailHeaderView.h"
#import "ShareOperation.h"

@interface ReceiveDetailHeaderView ()
{
    UIButton *_flipButton;
    UIView *_mainBgView;
    UIImageView *_backView;
    UIImageView *_frontView;
    ReceiveDetailModel *_cardModel;
}
@end

@implementation ReceiveDetailHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setContent:(ReceiveDetailModel *)cardModel
{
    self.contentView.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0];
    _cardModel = cardModel;
    
    if (!cardModel) {
        return;
    }
    // 正反面父视图
    _mainBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kCardHeight * kScreenWidth / kCardWidth)];
    _mainBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    _mainBgView.layer.shadowOpacity = 0.7;
    _mainBgView.layer.shadowOffset = CGSizeMake(0, 0);
    _mainBgView.layer.shadowRadius = 2.0;
    [self.contentView addSubview:_mainBgView];
    
    _backView = [[UIImageView alloc] initWithFrame:_mainBgView.bounds];
    [Constants setImageView:_backView path:cardModel.postcard_back];
    [_mainBgView addSubview:_backView];
    
    _frontView = [[UIImageView alloc] initWithFrame:_mainBgView.bounds];
    [Constants setImageView:_frontView path:cardModel.postcard_head];
    [_mainBgView addSubview:_frontView];
    UIView *viewbutton = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mainBgView.frame) + 10, kScreenWidth, 50)];
    viewbutton.backgroundColor = [UIColor whiteColor];
    UIButton *publicButton = [Constants createButton:CGRectMake(20, 10, 100, 30) title:nil target:self sel:@selector(handlePublic:) color:kGreenColor];
    [publicButton setTitle:NSLocalizedString(@"localized059", nil) forState:UIControlStateNormal];
    [publicButton setTitle:NSLocalizedString(@"localized060", nil) forState:UIControlStateSelected];
    publicButton.selected = cardModel.sharing_state == 1 ? NO : YES;
    publicButton.layer.cornerRadius = 10;
    publicButton.layer.borderColor = kGColor.CGColor;
    publicButton.layer.borderWidth = 1;
    [self handlePublicComplete:publicButton];
    [viewbutton addSubview:publicButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(kScreenWidth - 40 - 10, 5, 40, 40);
    [shareButton setImage:[UIImage imageNamed:@"public-share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [viewbutton addSubview:shareButton];
    [self.contentView addSubview:viewbutton];
}

+ (CGFloat)height
{
    return 20 + kCardHeight * kScreenWidth / kCardWidth + 50 + 2;
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
// （取消）公开
- (void)handlePublic:(UIButton *)button
{
    __weak typeof(self) weakself = self;
    if (button.isSelected) { // 取消公开
        NetworkRequest *request = [[NetworkRequest alloc] init];
        [request completion:^(id result, BOOL succ) {
            if (succ) {
                button.selected = !button.isSelected;
                [weakself handlePublicComplete:button];
            }
        }];
        [request cancelPublicCard:_cardModel.postcard_id];
    } else { // 公开
        NetworkRequest *request = [[NetworkRequest alloc] init];
        [request completion:^(id result, BOOL succ) {
            if (succ) {
                button.selected = !button.isSelected;
                [weakself handlePublicComplete:button];
            }
        }];
        [request publicCard:_cardModel.postcard_id];
    }
}

- (void)handlePublicComplete:(UIButton *)button
{
    [Constants setPublicButtonColor:button.isSelected ? kRedColor : kGreenColor button:button];
    if (self.publicBlock) {
        self.publicBlock(button.isSelected);
    }
}

// 分享
- (void)share:(UIButton *)button
{
    [[ShareOperation shareInstance] showShareView:button imagePath:_cardModel.postcard_head image:_frontView.image complete:nil];
}

@end
