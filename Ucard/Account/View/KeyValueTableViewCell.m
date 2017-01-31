//
//  KeyValueTableViewCell.m
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "KeyValueTableViewCell.h"
#import "UIView+Frame.h"

@implementation KeyValueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        int cellHeight = kKeyValueTableViewCellHeight;
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
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, (kScreenWidth - 15 * 2) / 2.0f, cellHeight)];
        _keyLabel.textColor = [UIColor lightGrayColor];
        _keyLabel.font = [UIFont systemFontOfSize:fontSmall];
        [self.contentView addSubview:_keyLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:_keyLabel.frame];
        [_valueLabel setFrameOriginX:CGRectGetMaxX(_keyLabel.frame)];
        [_valueLabel setFrameWidth:CGRectGetWidth(_keyLabel.frame)];
        _valueLabel.textAlignment = NSTextAlignmentRight;
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
