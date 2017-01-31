//
//  ReceiveDetailKeyValueCell.m
//  Ucard
//
//  Created by Conner Wu on 15/5/9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ReceiveDetailKeyValueCell.h"

@implementation ReceiveDetailKeyValueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        int cellHeight = 35;
        int keyWidth = (kScreenWidth - 40 ) / 5 * 2;
        int fontSmall = 13;
        if(kR35){
            cellHeight = 35;
            fontSmall = 11;
        }
        else if(kR40){
            cellHeight = 44;
            fontSmall = 13;
        }
        else if(kR47){
            cellHeight = 50;
            fontSmall = 15;
        }
        else if(kR55){
            cellHeight = 60;
            fontSmall = 17;
        }
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, keyWidth, cellHeight)];
        _keyLabel.textColor = kGColor;
        _keyLabel.font = [UIFont systemFontOfSize:fontSmall];
        [self.contentView addSubview:_keyLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:_keyLabel.frame];
        CGRect frame = _valueLabel.frame;
        frame.origin.x = CGRectGetMaxX(_keyLabel.frame) + 5;
        frame.size.width = kScreenWidth - CGRectGetWidth(_keyLabel.frame) - 40 - 5;
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.frame = frame;
        _valueLabel.font = [UIFont systemFontOfSize:fontSmall];
        _valueLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_valueLabel];
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, _keyLabel.frame.size.height - 1, kScreenWidth, 1)];
        separatorView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0].CGColor;
        separatorView.layer.borderWidth = 1.0;
        [self.contentView addSubview:separatorView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
