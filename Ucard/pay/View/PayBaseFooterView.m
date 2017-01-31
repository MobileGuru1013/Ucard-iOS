//
//  PayBaseFooterView.m
//  Ucard
//
//  Created by WuLeilei on 15/5/27.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PayBaseFooterView.h"

@implementation PayBaseFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth - 10 * 2, 20)];
        _label.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)submit
{
    if (self.submitBlock) {
        self.submitBlock();
    }
}

@end
