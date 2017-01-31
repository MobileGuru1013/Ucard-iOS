//
//  FrontBgView.m
//  Ucard
//
//  Created by WuLeilei on 15/4/9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "FrontBgView.h"
#import "EffectButton.h"
#import "UIImage+TintColor.h"

@interface FrontBgView ()
{
    UISlider *_slider;
    UIButton *_frameButton;
    EffectButton *_lightButton;
    EffectButton *_fullButton;
    EffectButton *_compareButton;
}
@end

@implementation FrontBgView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat toolX = 75;

        CGFloat wlabel ;
        
        if(kR35) wlabel = 60;
        else if(kR40) wlabel =60;
        else if(kR47) wlabel =80;
        else if(kR55) wlabel = 100;
        
        CGFloat effectKeyY = 0;
        CGFloat frameKeyY = 0;
        NSArray *keyArray = @[NSLocalizedString(@"localized220", nil),
                              NSLocalizedString(@"localized221", nil),
                              NSLocalizedString(@"localized222", nil)];
        for (NSUInteger i = 0; i < keyArray.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((0+ 100) * i, 100,wlabel, 20)];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont boldSystemFontOfSize:12];
            label.text = keyArray[i];
            label.textColor=kGColor;
            
            [self addSubview:label];
            
            switch (i) {
                case 0:
                    effectKeyY = CGRectGetMinY(label.frame);
                    break;
                    
                case 1:
                    frameKeyY = CGRectGetMinY(label.frame);
                    break;
                    
                default:
                    break;
            }
        }
        
        // 效果
        NSArray *effectArray = @[@{@"imageGray": @"hide", @"imageGreen": @"show"},
                                 @{@"imageGray": @"hide", @"imageGreen": @"show"},
                                 @{@"imageGray": @"hide", @"imageGreen": @"show"}];
        for (NSUInteger i = 0; i < effectArray.count; i++) {
            NSDictionary *dic = [effectArray objectAtIndex:i];
            CGFloat hbutton ;
            CGFloat wbutton ;
            
            if(kR35) hbutton = 20;
            else if(kR40) hbutton =15;
            else if(kR47) hbutton = 22;
            else if(kR55) hbutton = 30;
            
            
            if(kR35) wbutton = 80;
            else if(kR40) wbutton =80;
            else if(kR47) wbutton = 90;
            else if(kR55) wbutton = 100;
            
            
            int margin = (self.frame.size.width - wbutton * 3 - hbutton * 2) / 2;
            EffectButton *button = [[EffectButton alloc]init];
            button.frame=CGRectMake(hbutton + (margin+wbutton) * i, 30, wbutton , 70);
            button.tag = i;
            button.label.text = [dic objectForKey:@"title"];
            button.label.textAlignment = NSTextAlignmentCenter;
            [button setImage:[UIImage imageNamed:[dic objectForKey:@"imageGray"]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[dic objectForKey:@"imageGreen"]] forState:UIControlStateSelected];
            //            [button addTarget:self action:@selector(effectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            switch (i) {
                case 0:
                    _lightButton = button;
                    break;
                    
                case 1:
                    _fullButton = button;
                    break;
                    
                case 2:
                    _compareButton = button;
                    break;
                    
                default:
                    break;
            }
            [self effectButtonClicked:_lightButton];
        }
    }
    return self;
}

#pragma mark 效果

- (void)effectButtonClicked:(UIButton *)button
{
    _lightButton.selected = NO;
    _fullButton.selected = NO;
    _compareButton.selected = NO;
    
    button.selected = YES;
    
    switch (button.tag) {
        case 0:
            [self setLight];
            break;
            
        case 1:
            [self setFull];
            break;
            
        case 2:
            [self setCompare];
            break;
            
        default:
            break;
    }
}

// 将slider设置为选中的效果值

- (void)setLight
{
    _slider.value = [Singleton shareInstance].cardModel.brightness;
}

- (void)setFull
{
    _slider.value = [Singleton shareInstance].cardModel.saturate;
}

- (void)setCompare
{
    _slider.value = [Singleton shareInstance].cardModel.contrast;
}

// 更改效果
- (void)sliderChanged:(UISlider *)slider
{
    BOOL flag = NO;
    if (_lightButton.isSelected) {
        double dt = [Singleton shareInstance].cardModel.brightness - slider.value;
        if (fabs(dt) >= 0.1) {
            [Singleton shareInstance].cardModel.brightness = slider.value;
            flag = YES;
        }
    } else if (_fullButton.isSelected) {
        double dt = [Singleton shareInstance].cardModel.saturate - slider.value;
        if (fabs(dt) >= 0.1) {
            [Singleton shareInstance].cardModel.saturate = slider.value;
            flag = YES;
        }
    } else if (_compareButton.isSelected) {
        double dt = [Singleton shareInstance].cardModel.contrast - slider.value;
        if (fabs(dt) >= 0.1) {
            [Singleton shareInstance].cardModel.contrast = slider.value;
            flag = YES;
        }
    }
    if (flag) {
        if (self.refreshImageBlock) {
            self.refreshImageBlock();
        }
    }
}

// 拖完后保存
- (void)saveSlider:(UISlider *)slider
{
    [Singleton shareInstance].cardModel.hasUploaded = NO;
    [[Singleton shareInstance].cardModel updateData];
}

#pragma mark 边框

- (void)handleFrame:(UIButton *)button
{
    [Singleton shareInstance].cardModel.hasUploaded = NO;
    [[Singleton shareInstance].cardModel updateData];
    
    button.selected = !button.isSelected;
    
    [self showFrame:button.isSelected];
}

- (void)showFrame:(BOOL)flag
{
    [Singleton shareInstance].cardModel.frame = flag;
    [[Singleton shareInstance].cardModel updateData];
    
    if (self.refreshImageBlock) {
        self.refreshImageBlock();
    }
}

- (void)setContent
{
    // 亮度
    [self effectButtonClicked:_lightButton];
    
    // 边框
    bool isFrame = [Singleton shareInstance].cardModel.frame;
    [self showFrame:isFrame];
}

@end
