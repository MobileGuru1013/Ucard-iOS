//
//  CommunityDetailCell.m
//  Ucard
//
//  Created by WuLeilei on 15/5/10.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommunityDetailCell.h"
#import "NSString+TimeAgo.h"

@interface CommunityDetailCell ()
{
    UIImageView *_header;
    UILabel *_name;
    UILabel *_from;
    UIImageView *_front;
    UILabel *_priseLabel;
    UILabel *_commentLabel;
    UILabel *_time;
    UIView *logoview;
    UIButton* editbt;
    UIButton *priseButton;
  
    
    
}
@end

@implementation CommunityDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        _header = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 25+20, 25+20)];
        _header.layer.cornerRadius = CGRectGetHeight(_header.frame) / 2.0;
        [self.contentView addSubview:_header];
	
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_header.frame) + 8+10, CGRectGetMinY(_header.frame) + 3, kScreenWidth / 2 - CGRectGetMaxX(_header.frame) - 8, CGRectGetHeight(_header.frame) - 3)];
        _name.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_name];
        
        _front = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_header.frame) + 5, kScreenWidth, kCardHeight * kScreenWidth / kCardWidth)];
        
        _front.userInteractionEnabled = YES;
        _front.layer.borderWidth = 0.5;
        _front.layer.borderColor = [UIColor colorWithWhite:0.667 alpha:0.50].CGColor;
        [self.contentView addSubview:_front];
        
        
        editbt= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -60, CGRectGetMinY(_name.frame)+1, 35, 35)];
        [editbt setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        
        [editbt addTarget:self action:@selector(shareUcard) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editbt];
           
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_front.frame) -50, CGRectGetWidth(_front.frame), 30+20)];
        
        bgImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        bgImageView.userInteractionEnabled = YES;
        [_front addSubview:bgImageView];
        
        
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame =CGRectMake(0+15, 10, 40, 30);
        [commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:commentButton];
        
        _commentLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentButton.frame) - 3, 0, 50, 50)];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.font = _priseLabel.font;
        [bgImageView addSubview:_commentLabel];
        
        
        priseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        priseButton.frame = CGRectMake(CGRectGetMaxX(_commentLabel.frame) + 2, 5, 40, 30);
        [priseButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [priseButton addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:priseButton];
        
        _priseLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priseButton.frame) - 3, 0, 50, 50)];
        _priseLabel.textColor = [UIColor whiteColor];
        _priseLabel.font = _name.font;
        [bgImageView addSubview:_priseLabel];
       
        _from=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2 - 10, 30+20)];
        _from.font = _name.font;
        _from.textColor=[UIColor whiteColor];
        _from.textAlignment = NSTextAlignmentRight;
        [bgImageView addSubview:_from];

        logoview = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth / 2), CGRectGetMinY(_name.frame)+50, 165, 50)];
        logoview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        logoview.userInteractionEnabled = YES;
        
        UIButton* camerabt = [[UIButton alloc] initWithFrame:CGRectMake(0, -2, 50, 50)];
        [camerabt setImage:[UIImage imageNamed:@"ms_camera"] forState:UIControlStateNormal];
        [logoview addSubview:camerabt];
        
        UIButton* facebookbt = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(camerabt.frame)+30, 0, 50, 50)];
        [facebookbt setImage:[UIImage imageNamed:@"ms_facebook"] forState:UIControlStateNormal];
        [logoview addSubview:facebookbt];
        
        UIButton* sinabt = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(facebookbt.frame)+30, 0, 50, 50)];
        [sinabt setImage:[UIImage imageNamed:@"ms_sina"] forState:UIControlStateNormal];
        [logoview addSubview:sinabt];

    }
    return self;
}



- (UIImageView *)setContent:(CommunityDetaiModel *)model
{
    [Constants setHeaderImageView:_header path:model.user_icon];
    _name.text = model.user_nickname;
    _from.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"", nil), [Constants getLocalizedCountry:model.original_country]];
    
    [Constants setImageView:_front path:model.postcard_head];
    _priseLabel.text = [NSString stringWithFormat:@"%ld%@", (long)model.like_number, NSLocalizedString(@"localized019", nil)];
    _commentLabel.text = [NSString stringWithFormat:@"%ld%@", (long)model.comment_number, NSLocalizedString(@"localized020", nil)];
    _time.text = [model.postcard_making_time timeAgo];
    return _front;
}

+ (CGFloat)height
{
    return 67 + kCardHeight * kScreenWidth / kCardWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)praise
{
    if (self.praiseBlock) {
        self.praiseBlock();
    
        _priseLabel.frame= CGRectMake(CGRectGetMaxX(priseButton.frame)-20, 0, 50, 50);
        _priseLabel.textColor = [UIColor whiteColor];
        _priseLabel.font = [UIFont boldSystemFontOfSize:25.0];
        _priseLabel.transform = CGAffineTransformScale(_priseLabel.transform, .25, .25);
        [_priseLabel sizeToFit];
        
        [UIView animateWithDuration:1.0 animations:^{
            _priseLabel.transform = CGAffineTransformScale(_priseLabel.transform, 4.0, 4.0);
        } completion:^(BOOL finished) {
            _priseLabel.frame= CGRectMake(CGRectGetMaxX(priseButton.frame) - 3,15, 50, 50);
            _priseLabel.font = [UIFont boldSystemFontOfSize:15];
            [_priseLabel sizeToFit];
            
        }];
        
    }
}
- (void)comment
{
    if (self.commentBlock) {
        self.commentBlock();
    }
}
- (void)shareUcard
{
    if (self.shareBlock) {
        self.shareBlock();
    }
}

-(UIButton *) getShareButton {
    return editbt;
}

@end
