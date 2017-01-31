//
//  UserModel.h
//  Ucard
//
//  Created by WuLeilei on 15/4/12.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel
@property(nonatomic,strong) NSString * username;
@property(nonatomic,strong) NSString * password;
@property(nonatomic,strong) NSString * type;
@property(nonatomic,assign) NSInteger commentNoti;
@property(nonatomic,assign) NSInteger likeNoti;
@property(nonatomic,assign) NSInteger receivedNoti;

+ (void)signinSucceed:(NSString *)uid user:(NSString *)user password:(NSString *)password type:(NSString *)type;
+ (NSArray *)getAccount;
+ (UserModel *)getAccountModel;
- (BOOL)updateData;
+ (void)destory;
+ (void)updatePassword:(NSString *)password;

@end
