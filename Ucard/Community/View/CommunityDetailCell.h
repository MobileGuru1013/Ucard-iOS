//
//  CommunityDetailCell.h
//  Ucard
//
//  Created by WuLeilei on 15/5/10.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityDetaiModel.h"

@interface CommunityDetailCell : UITableViewCell

@property (nonatomic, strong) void (^praiseBlock) ();
@property (nonatomic, strong) void (^commentBlock) ();
@property (nonatomic, strong) void (^shareBlock) ();


+ (CGFloat)height;
- (UIImageView *)setContent:(CommunityDetaiModel *)model;
-(UIButton *) getShareButton;

@end
