//
//  ProfileHeaderTableViewCell.m
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ProfileHeaderTableViewCell.h"

@implementation ProfileHeaderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        int fontSmall = 13;
        int cellHeight;
        int imageHeight = 40;
        if(kR35){
            cellHeight = 42;
            imageHeight = 30;
            fontSmall = 13;
        }
        else if(kR40){
            cellHeight = 54;
            fontSmall = 16;
        }
        else if(kR47){
            cellHeight = 60;
            fontSmall = 18;
        }
        else if(kR55){
            cellHeight = 70;
            fontSmall = 20;
        }
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (cellHeight - imageHeight) / 2.0f, imageHeight, imageHeight)];
        _headerImageView.layer.cornerRadius = CGRectGetHeight(_headerImageView.frame) / 2;
        _headerImageView.image = [UIImage imageNamed:@"account-header-default"];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 15,(cellHeight - 40) / 2.0f, self.contentView.frame.size.width - CGRectGetMaxX(_headerImageView.frame) + 15, 40.0f)];
        _userName.font = [UIFont boldSystemFontOfSize:fontSmall];
        _userName.textColor = kGColor;
        
        [self.contentView addSubview:_userName];
        [self.contentView addSubview:_headerImageView];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-1, kScreenWidth, 1)];
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
