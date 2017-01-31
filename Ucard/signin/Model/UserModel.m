//
//  UserModel.m
//  Ucard
//
//  Created by WuLeilei on 15/4/12.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (void)signinSucceed:(NSString *)uid user:(NSString *)user password:(NSString *)password type:(NSString *)type
{
#warning Test
    [Singleton shareInstance].uid = uid;
    [[DatabaseManager shareInstance] checkUserDatabase:uid];
    
    // 删除用户信息
    BOOL succ = [self deleteAccount];
    
    // 保存用户名密码
    succ = [[DatabaseManager shareInstance].publicDB executeUpdateWithFormat:@"INSERT INTO account (user, password, type) VALUES (%@, %@, %@)", user, password, type];
    if (!succ) {
        NSLog(@"%@", [[DatabaseManager shareInstance].publicDB lastError]);
    }
}

+ (BOOL)deleteAccount
{
    BOOL succ = [[DatabaseManager shareInstance].publicDB executeUpdate:@"DELETE FROM account"];
    if (!succ) {
        NSLog(@"%@", [[DatabaseManager shareInstance].publicDB lastError]);
    }
    return succ;
}

+ (NSArray *)getAccount
{
    NSArray *array;
    FMResultSet *rs = [[DatabaseManager shareInstance].publicDB executeQuery:@"SELECT * FROM account LIMIT 1"];
    if ([rs next]) {
        NSDictionary *dic = [rs resultDictionary];
        NSString *user = [dic objectForKey:@"user"];
        NSString *password = [dic objectForKey:@"password"];
        NSString *type = [dic objectForKey:@"type"];
        array = @[user, password ? password : @"", type];
    }
    return array;
}
+ (UserModel *)getAccountModel
{
    UserModel *model;
    FMResultSet *rs = [[DatabaseManager shareInstance].publicDB executeQuery:@"SELECT * FROM account LIMIT 1"];
    if ([rs next]) {
        model = [[UserModel alloc] init];
        NSDictionary *dic = [rs resultDictionary];
        model.username = [dic objectForKey:@"user"];
        model.password = [dic objectForKey:@"password"];
        if (!model.password) {
            model.password = @"";
        }
        model.type = [dic objectForKey:@"type"];
        model.commentNoti = [[dic objectForKey:@"commentNoti"] integerValue];
        model.likeNoti = [[dic objectForKey:@"likeNoti"] integerValue];
        model.receivedNoti = [[dic objectForKey:@"receiveNoti"] integerValue];
    }
    return model;
}
- (BOOL)updateData
{
    BOOL succ = [[DatabaseManager shareInstance].publicDB executeUpdateWithFormat:@"UPDATE account SET user = %@, password = %@, type = %@, commentNoti = %ld, likeNoti = %ld, receiveNoti = %ld", _username, _password, _type, _commentNoti, _likeNoti, _receivedNoti];
    if (!succ) {
        NSLog(@"%@", [[DatabaseManager shareInstance].publicDB lastError]);
    }
    return succ;
}
+ (void)updatePassword:(NSString *)password
{
    BOOL succ = [[DatabaseManager shareInstance].publicDB executeUpdateWithFormat:@"UPDATE account SET password = %@", password];
    if (!succ) {
        NSLog(@"%@", [[DatabaseManager shareInstance].publicDB lastError]);
    }
}

+ (void)destory
{
    [self deleteAccount];
    
    [[Singleton shareInstance] destory];
}

@end
