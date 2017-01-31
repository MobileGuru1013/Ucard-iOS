//
//  AddressTextFieldCell.m
//  Ucard
//
//  Created by Conner Wu on 15/4/27.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AddressTextFieldCell.h"
#import "CardBasePopView.h"

@implementation AddressTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(30, 5, kPopWidth - 30 * 2, 50 - 10)];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.floatingLabelFont = [UIFont boldSystemFontOfSize:11];
        _textField.floatingLabelTextColor = [UIColor grayColor];
        _textField.floatingLabelActiveTextColor = kGreenColor;
        _textField.clearButtonMode = UITextFieldViewModeNever;
        _textField.layer.borderColor = [UIColor grayColor].CGColor;
        _textField.layer.borderWidth = 1;
        _textField.layer.cornerRadius =  4;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, _textField.frame.size.height)];
        [_textField setLeftViewMode:UITextFieldViewModeAlways];
        [_textField setLeftView:paddingView];
        [self.contentView addSubview:_textField];
        _textField.keepBaseline = 1;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
