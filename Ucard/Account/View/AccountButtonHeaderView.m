//
//  AccountButtonHeaderView.m
//  Ucard
//
//  Created by Conner Wu on 15/5/7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountButtonHeaderView.h"
#import "AccountCardButton.h"

@interface AccountButtonHeaderView ()

@end

@implementation AccountButtonHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 草稿、寄信、收信
        NSArray *array = @[@{@"text": NSLocalizedString(@"localized056", nil), @"sel": @"getDraft:"},
                           @{@"text": NSLocalizedString(@"localized057", nil), @"sel": @"getSend:"},
                           @{@"text": NSLocalizedString(@"localized058", nil), @"sel": @"getReceive:"}];
        CGFloat width = kScreenWidth / array.count;
        [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            AccountCardButton *button = [[AccountCardButton alloc] initWithFrame:CGRectMake(width * idx, 0, width, [AccountButtonHeaderView height])];
            [button setTitleColor:[UIColor  lightGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:kWhiteColor forState:UIControlStateSelected];
            [button setTitle:[dic objectForKey:@"text"] forState:UIControlStateNormal];
            
            [button addTarget:self action:NSSelectorFromString([dic objectForKey:@"sel"]) forControlEvents:UIControlEventTouchUpInside];
            
            button.backgroundColor=kGColor;
            button.layer.cornerRadius =  1;
            button.layer.borderColor = kGColor.CGColor;
            button.layer.borderWidth = 1;
            
            
            
            [self.contentView addSubview:button];
            ;
            switch (idx) {
                case 0:
                    _draftButton = button;
                    break;
                    
                case 1:
                    _sendButton = button;
                    break;
                    
                case 2:
                    _receiveButton = button;
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self getDraft:_draftButton];
        
        // line
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_draftButton.frame) - 0.5, kScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.5;
        [self.contentView insertSubview:line belowSubview:_draftButton];
    }
    return self;
}

+ (CGFloat)height
{
    return 40;
}

- (void)getDraft:(AccountCardButton *)button
{
    if (_draftButton.isSelected) {
        return;
    }
    
    _draftButton.selected = YES;
    _sendButton.selected = NO;
    _receiveButton.selected = NO;
    _draftButton.backgroundColor = kGColor;
    _sendButton.backgroundColor = [UIColor whiteColor];
    _receiveButton.backgroundColor = [UIColor whiteColor];
    
    if (self.draftBlock) {
        self.draftBlock();
    }
}

- (void)getSend:(AccountCardButton *)button
{
    if (_sendButton.isSelected) {
        return;
    }
    
    _draftButton.selected = NO;
    _sendButton.selected = YES;
    _receiveButton.selected = NO;
    _sendButton.backgroundColor = kGColor;
    _draftButton.backgroundColor = [UIColor whiteColor];
    _receiveButton.backgroundColor = [UIColor whiteColor];
    
    if (self.sendBlock) {
        self.sendBlock();
    }
}

- (void)getReceive:(AccountCardButton *)button
{
    if (_receiveButton.isSelected) {
        return;
    }
    
    _draftButton.selected = NO;
    _sendButton.selected = NO;
    _receiveButton.selected = YES;
    _receiveButton.backgroundColor = kGColor;
    _sendButton.backgroundColor = [UIColor whiteColor];
    _draftButton.backgroundColor = [UIColor whiteColor];
    
    if (self.receiveBlock) {
        self.receiveBlock();
    }
}

@end
