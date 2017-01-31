//
//  AddressCountryCell.m
//  Ucard
//
//  Created by Conner Wu on 15/4/27.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AddressCountryCell.h"
#import "CardBasePopView.h"

@implementation AddressCountryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(30, 5, kPopWidth - 60, 50 - 10)];
        paddingView.layer.borderColor = [UIColor grayColor].CGColor;
        paddingView.layer.borderWidth = 1;
        paddingView.layer.cornerRadius =  4;
        
        [self.contentView addSubview:paddingView];
        CGRect frame = paddingView.frame;
        frame.origin.x = 15;
        frame.size.width -= 30;
        frame.origin.y = 0;
        _textLbl = [[UILabel alloc] initWithFrame:frame];
        
        _textLbl.font = [UIFont systemFontOfSize:16];
        _textLbl.textColor = [UIColor grayColor];
        [paddingView addSubview:_textLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
