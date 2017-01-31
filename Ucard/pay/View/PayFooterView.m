//
//  PayFooterView.m
//  Ucard
//
//  Created by WuLeilei on 15/5/27.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PayFooterView.h"

@implementation PayFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *payButton = [Constants createGreenButton:CGRectMake(10, 60, kScreenWidth - 10 * 2, 40) title:NSLocalizedString(@"localized029", nil) sel:@selector(submit) target:self];
        [self.contentView addSubview:payButton];
    }
    return self;
}

- (void)submit
{
    [super submit];
}

@end
