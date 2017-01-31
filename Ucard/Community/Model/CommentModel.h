//
//  CommentModel.h
//  Ucard
//
//  Created by WuLeilei on 15/5/11.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel

@property (nonatomic, strong) NSString *user_nickname;
@property (nonatomic, strong) NSString *user_icon;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *time;

@end
