//
//  PayTableViewCell.m
//  Ucard
//
//  Created by Conner Wu on 15/4/29.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label.frame), 0, kScreenWidth, 44)];
        _label.font = [UIFont systemFontOfSize:17];
         _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        
        
        _textfield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textfield.frame),0, kScreenWidth, 44)];
        _textfield.font = [UIFont systemFontOfSize:17];
        _textfield.textAlignment = NSTextAlignmentCenter;
        _textfield.textColor =[UIColor lightGrayColor];
        [self.contentView addSubview:_textfield];
        
        
        
       _button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label.frame), 0, kScreenWidth, 44)];
        _button.font = [UIFont systemFontOfSize:17];
        
         
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
