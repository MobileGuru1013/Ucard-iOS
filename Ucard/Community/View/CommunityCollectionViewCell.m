//
//  CommunityCollectionViewCell.m
//  Ucard
//
//  Created by WuLeilei on 15/5/7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommunityCollectionViewCell.h"

@implementation CommunityCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    int bgImageViewHeight = 30;
    if(kR35){
        bgImageViewHeight = 35;
    }
    else if(kR40){
        bgImageViewHeight = 45;
    }
    else if(kR47){
        bgImageViewHeight = 60;
    }
    else if(kR55){
        bgImageViewHeight = 80;
    }
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.borderWidth = 0.5;
        _imageView.layer.borderColor = [UIColor colorWithWhite:0.667 alpha:0.50].CGColor;
        [self.contentView addSubview:_imageView];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - bgImageViewHeight, CGRectGetWidth(frame), bgImageViewHeight)];
        bgImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        bgImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:bgImageView];
        
        UIButton *priseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        priseButton.frame = CGRectMake(bgImageViewHeight / 3, bgImageViewHeight / 3, bgImageViewHeight / 3, bgImageViewHeight / 3);
        [priseButton setImage:[UIImage imageNamed:@"community-prise-s"] forState:UIControlStateNormal];
        [bgImageView addSubview:priseButton];
        
        _priseLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priseButton.frame) + 10, CGRectGetMinY(priseButton.frame), CGRectGetWidth(priseButton.frame) + 20, bgImageViewHeight / 3)];
        _priseLabel.textColor = [UIColor whiteColor];
        _priseLabel.font = [UIFont systemFontOfSize:13];
        [bgImageView addSubview:_priseLabel];
        
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(CGRectGetMaxX(_priseLabel.frame) + 20,CGRectGetMinY(priseButton.frame) , CGRectGetWidth(priseButton.frame) , bgImageViewHeight / 3);
        [commentButton setImage:[UIImage imageNamed:@"community-comment-s"] forState:UIControlStateNormal];
        [bgImageView addSubview:commentButton];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentButton.frame) + 10,CGRectGetMinY(commentButton.frame) , CGRectGetWidth(commentButton.frame)  + 20, bgImageViewHeight / 3)];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.font = _priseLabel.font;
        [bgImageView addSubview:_commentLabel];
        
        _countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_commentLabel.frame) + 10,CGRectGetMinY(_commentLabel.frame) , frame.size.width - 30 - CGRectGetMaxX(_commentLabel.frame) - 10, bgImageViewHeight / 3)];
        _countryLabel.textColor = [UIColor whiteColor];
        _countryLabel.font = _priseLabel.font;
        _countryLabel.textAlignment = NSTextAlignmentRight;
        
        [bgImageView addSubview:_countryLabel];
        
    }
    return self;
}

+ (CGFloat)width
{
    return (kScreenWidth - 2);
}

@end
