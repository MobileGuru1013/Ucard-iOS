//
//  CommunityCommentCell.h
//  Ucard
//
//  Created by WuLeilei on 15/5/10.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityCommentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

+ (CGFloat)height:(NSString *)text;
- (void)setContentHeight:(NSString *)text;

@end
