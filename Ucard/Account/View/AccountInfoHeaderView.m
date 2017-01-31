//
//  AccountInfoHeaderView.m
//  Ucard
//
//  Created by WuLeilei on 15/5/2.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountInfoHeaderView.h"

@implementation AccountInfoHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 15 * 2, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_label];
    }
    return self;
}

@end
