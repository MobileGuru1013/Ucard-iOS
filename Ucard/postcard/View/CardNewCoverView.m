//
//  CardNewCoverView.m
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CardNewCoverView.h"

@implementation CardNewCoverView

UIButton *button;
UILabel *label;
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.6];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frameBtt = frame;
        frameBtt.origin.x = 0;
        frameBtt.origin.y = 0;
        button.frame = frameBtt;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 10;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:40];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"postcard_create_button"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) - 30 - 20, kScreenWidth, 20)];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"localized108", nil);
        [self addSubview:label];
    }
    return self;
}

- (void)showAlbum
{
    if (self.showAlbumBlock) {
        self.showAlbumBlock();
    }
}

- (void) setTranparent {
    self.backgroundColor = [UIColor clearColor];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderColor = [UIColor clearColor].CGColor;
    [button setImage:nil forState:UIControlStateNormal];
    button.layer.borderWidth = 0;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 0;
    label.text = @"";
    label.backgroundColor = [UIColor clearColor];
}

@end
