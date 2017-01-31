//
//  SignupTableViewCell.m
//  Ucard
//
//  Created by Conner Wu on 15-4-8.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SignupTableViewCell.h"

@implementation SignupTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (44 - 20) / 2, 20, 15)];
        [self.contentView addSubview:_iconImageView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10, 0, kScreenWidth - CGRectGetMaxX(_iconImageView.frame) - 10 - 80 - 10 * 2, 44)];
        _textField.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_textField];
        _textField.textColor=[UIColor whiteColor];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
