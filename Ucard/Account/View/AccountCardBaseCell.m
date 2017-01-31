//
//  AccountCardBaseCell.m
//  Ucard
//
//  Created by Conner Wu on 15/5/7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountCardBaseCell.h"

@implementation AccountCardBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 10 * 2, [AccountCardBaseCell height] - 10 *2)];
        _photoImageView.layer.borderWidth = 0.5;
        _photoImageView.layer.borderColor = [UIColor colorWithWhite:0.667 alpha:0.50].CGColor;
        [self.contentView addSubview:_photoImageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)height
{
    return (kCardHeight / kCardWidth) * (kScreenWidth - 10 * 2) + 10 * 2;
}

@end
