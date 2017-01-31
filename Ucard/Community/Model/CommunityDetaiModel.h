//
//  CommunityDetaiModel.h
//  Ucard
//
//  Created by WuLeilei on 15/5/10.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"

@interface CommunityDetaiModel : BaseModel

@property (nonatomic, strong) NSString *postcard_uid;
@property (nonatomic, strong) NSString *postcard_head;
@property (nonatomic, assign) NSInteger like_number;
@property (nonatomic, assign) NSInteger postcard_comment_number;// for 社区
@property (nonatomic, assign) NSInteger comment_number;// for 社区详情
@property (nonatomic, strong) NSString *user_icon;
@property (nonatomic, strong) NSString *user_nickname;
@property (nonatomic, strong) NSString *original_country;
@property (nonatomic, strong) NSString *postcard_making_time;

+ (BOOL)isPraised:(NSString *)cardId;
+ (BOOL)praiseCard:(NSString *)cardId;

@end
