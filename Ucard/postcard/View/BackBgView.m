//
//  BackBgView.m
//  Ucard
//
//  Created by WuLeilei on 15/4/9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BackBgView.h"
#import "BackInfoButton.h"

@interface BackBgView ()
{
    BackInfoButton *_textButton;
    BackInfoButton *_signButton;
    BackInfoButton *_addressButton;
    BackInfoButton *_listButton;
}
@end

@implementation BackBgView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSArray *array = @[@{@"image": @"greeting"},
                           @{@"image": @"signature"},
                           @{@"image": @"address"},
                           @{@"image": @"rain"}];
        
        CGFloat width = 40;
        CGFloat marginH = 30;
        CGFloat marginLeft = (kScreenWidth - (array.count - 1) * marginH - width * array.count) / 2;
        for (NSUInteger i = 0; i < array.count; i++) {
            NSDictionary *dic = [array objectAtIndex:i];
            
            BackInfoButton *button = [[BackInfoButton alloc] initWithFrame:CGRectMake(marginLeft + (width + marginH) * i, kR35 ? 30 : 50, width, width)];
            [button setImage:[UIImage imageNamed:[dic objectForKey:@"image"]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showTool:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            button.label.text = [dic objectForKey:@"title"];
            [self addSubview:button];
            
            switch (i) {
                case 0:
                    _textButton = button;
                    break;
                    
                case 1:
                    _signButton = button;
                    break;
                    
                case 2:
                    _addressButton = button;
                    break;
                case 3:
                    _listButton = button;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

- (void)showTool:(UIButton *)button
{
    if (self.toolBlock) {
        self.toolBlock(button.tag);
    }
}

- (void)setContent
{
    if ([Singleton shareInstance].cardModel.text.length > 0) {
        [_textButton setSelected:YES];
    } else {
        [_textButton setSelected:NO];
    }
    
    if ([Singleton shareInstance].cardModel.signImage) {
        [_signButton setSelected:YES];
    } else {
        [_signButton setSelected:NO];
    }
    
    if ([Singleton shareInstance].cardModel.country) {
        [_addressButton setSelected:YES];
    } else {
        [_addressButton setSelected:NO];
    }
    if ([Singleton shareInstance].cardModel.country) {
        [_listButton setSelected:YES];
    } else {
        [_listButton setSelected:NO];
    }

}

@end
