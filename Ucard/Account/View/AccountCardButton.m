//
//  AccountCardButton.m
//  Ucard
//
//  Created by WuLeilei on 15/5/6.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountCardButton.h"
#import "UIView+Frame.h"

@interface AccountCardButton ()
{
    UIImageView *_line;
}
@end

@implementation AccountCardButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleEdgeInsets = UIEdgeInsetsMake(16, 0, 0, 0);
        _countLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont boldSystemFontOfSize:15];
        _countLabel.text = @"0";
        _countLabel.textColor=[UIColor whiteColor];
        [_countLabel setFrameOriginY:0];
        [_countLabel setFrameHeight:20];
        [self addSubview:_countLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        _countLabel.textColor =[UIColor whiteColor];
    } else {
        _countLabel.textColor = [UIColor lightGrayColor];
    }
    _line.hidden = !selected;
}

@end
