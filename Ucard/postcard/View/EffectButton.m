//
//  EffectButton.m
//  Ucard
//
//  Created by WuLeilei on 15/4/11.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "EffectButton.h"

@implementation EffectButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageEdgeInsets = UIEdgeInsetsMake(-12, 0, 0, 0);
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 12, CGRectGetWidth(frame), 12)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:10];
        [self addSubview:_label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        _label.textColor = kGreenColor;
    } else {
        _label.textColor = [UIColor darkTextColor];
    }
}

@end
