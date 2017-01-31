//
//  CommunityDetaiModel.m
//  Ucard
//
//  Created by WuLeilei on 15/5/10.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommunityDetaiModel.h"

@implementation CommunityDetaiModel

+ (BOOL)isPraised:(NSString *)cardId

{
    FMResultSet *rs = [[DatabaseManager shareInstance].userDB executeQueryWithFormat:@"SELECT * FROM praise WHERE cardId = %@", cardId];
    if ([rs next]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)praiseCard:(NSString *)cardId
{
    BOOL succ = [[DatabaseManager shareInstance].userDB executeUpdateWithFormat:@"INSERT INTO praise (cardId) VALUES (%@)", cardId];
    if (!succ) {
        NSLog(@"%@", [DatabaseManager shareInstance].userDB.lastError);
    }
    return succ;
}

@end
