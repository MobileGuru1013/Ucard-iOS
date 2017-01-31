//
//  AddressCountryCell.m
//  Ucard
//
//  Created by Conner Wu on 15/4/27.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountInfoTableCell.h"
#import "CardBasePopView.h"

@implementation AccountInfoTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        _paddingView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, kPopWidth - 60, 50 - 10)];
        _paddingView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0].CGColor;
        _paddingView.layer.borderWidth = 1;
        _paddingView.layer.cornerRadius =  4;
        
        [self.contentView addSubview:_paddingView];
        CGRect frame = _paddingView.frame;
        frame.origin.x = 15;
        frame.size.width -= 30;
        frame.origin.y = 0;
        _textLbl = [[UILabel alloc] initWithFrame:frame];
        
        _textLbl.font = [UIFont systemFontOfSize:16];
        _textLbl.textColor = [UIColor lightGrayColor];
        [_paddingView addSubview:_textLbl];
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 57, kScreenWidth, 3)];
        separatorView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0].CGColor;
        separatorView.layer.borderWidth = 1.0;
        separatorView.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0];
        [self.contentView addSubview:separatorView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
