//
//  CommunityCommentCell.m
//  Ucard
//
//  Created by WuLeilei on 15/5/10.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommunityCommentCell.h"
#import "UIView+Frame.h"
#import "NSString+Size.h"

@implementation CommunityCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 25, 25)];
        _headerImageView.layer.cornerRadius = CGRectGetHeight(_headerImageView.frame) / 2.0;
        [self.contentView addSubview:_headerImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 7, 7, kScreenWidth - CGRectGetMaxX(_headerImageView.frame) - 7 - 10, 17)];
        _nameLabel.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:_nameLabel.frame];
        _timeLabel.textColor = [UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1];
        _timeLabel.font = _nameLabel.font;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:_nameLabel.frame];
        [_contentLabel setFrameOriginY:CGRectGetMaxY(_nameLabel.frame) + 3];
        _contentLabel.textColor = _timeLabel.textColor;
        _contentLabel.font = _timeLabel.font;
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
    }
    
    return self;
}

+ (CGFloat)height:(NSString *)text

{
    CGFloat textHeight = [text getHeightOfFont:[UIFont systemFontOfSize:15] width:kScreenWidth - 10 - 25 - 7 - 10];
    return 7 + 25 + 3 + textHeight;
}

- (void)setContentHeight:(NSString *)text

{
    CGFloat textHeight = [text getHeightOfFont:[UIFont systemFontOfSize:15] width:kScreenWidth - 10 - 25 - 7 - 10];
    [_contentLabel setHeight:textHeight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
