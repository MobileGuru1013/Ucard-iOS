//
//  ConfigModel.m
//  Ucard
//
//  Created by Conner Wu on 15/5/21.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ConfigModel.h"

@implementation ConfigModel

+ (NSString *)getValueByKey:(NSString *)key
{
    NSString *value;
    
    FMResultSet *rs = [[DatabaseManager shareInstance].publicDB executeQueryWithFormat:@"SELECT value FROM config WHERE key = %@", key];
    if ([rs next]) {
        NSDictionary *dic = [rs resultDictionary];
        value = [dic objectForKey:@"value"];
    }
    
    return value;
}

+ (BOOL)setValueByKey:(NSString *)key value:(NSString *)value
{
    BOOL succ = [[DatabaseManager shareInstance].publicDB executeUpdateWithFormat:@"UPDATE config SET value = %@ WHERE key = %@", value, key];
    if (!succ) {
        NSLog(@"%@", [DatabaseManager shareInstance].publicDB.lastError);
    }
    return succ;
}


+ (BOOL)isLaunched
{
    NSString *string = [ConfigModel getValueByKey:@"is_launched"];
    return [string boolValue];
}

+ (BOOL)setLaunched
{
    return [ConfigModel setValueByKey:@"is_launched" value:@"1"];
}

+ (BOOL)isReceived
{
    NSString *string = [ConfigModel getValueByKey:@"is_received"];
    return [string boolValue];
}

+ (BOOL)setReceived
{
    return [ConfigModel setValueByKey:@"is_received" value:@"1"];
}

@end
