//
//  BackInfoButton.m
//  Ucard
//
//  Created by WuLeilei on 15/4/11.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BackInfoButton.h"

@implementation BackInfoButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageEdgeInsets = UIEdgeInsetsMake(-12, 0, 0, 0);
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(-5, CGRectGetHeight(frame) - 10, CGRectGetWidth(frame) + 5 * 2, 12)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:10];
        [self addSubview:_label];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 16, 14, 14)];
        [self addSubview:_icon];
        
        [self setSelected:NO];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        _icon.image = [UIImage imageNamed:@"postcard_back_yes"];
    } else {
        _icon.image = [UIImage imageNamed:@"postcard_back_no"];
    }
}

@end
