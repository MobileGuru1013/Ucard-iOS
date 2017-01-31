//
//  DatabaseManager.m
//  ProjectARC
//
//  Created by WuLeilei on 15-2-2.
//  Copyright (c) 2015年 WuLeilei. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

// 获取单例
+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self checkPublicDatabase];
    }
    return self;
}

// 检测SandBox中是否有数据库文件，没有从资源库拷贝到SandBox
- (void)checkPublicDatabase
{
    [self checkDatabase:@"ucard-public.sqlite" targetName:@"ucard-public.sqlite" version:kPublicDBVersion publicDB:YES];
}

- (void)checkUserDatabase:(NSString *)userId
{
    [self checkDatabase:@"ucard.sqlite" targetName:[NSString stringWithFormat:@"ucard-%@.sqlite", userId] version:kUserDBVersion publicDB:NO];
}

- (void)checkDatabase:(NSString *)orginName targetName:(NSString *)targetName version:(float)version publicDB:(BOOL)publicDB
{
    NSArray *sandboxPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [sandboxPaths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:targetName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) { // SandBox中没有数据库文件
        // 检测资源库里面是否有数据库文件
        NSString *orginDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:orginName];
        success = [fileManager fileExistsAtPath:orginDBPath];
        if (success) {
            // 将数据库文件从资源库拷贝到SandBox
            NSError *error;
            success = [fileManager copyItemAtPath:orginDBPath toPath:dbPath error:&error];
            if (!success) {
                NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
        } else {
            NSLog(@"工程中没有数据库文件：%@", orginDBPath);
        }
    }
    if (success) {
        FMDatabase *database = [[FMDatabase alloc] initWithPath:dbPath];
        if (publicDB) {
            _publicDB = database;
        } else {
            _userDB = database;
        }
        if (![database open]) {
            NSLog(@"open db failed.");
        }
        [self checkDatabaseVersion:database orginName:orginName targetName:targetName version:version publicDB:publicDB];
        NSLog(@"%@", dbPath);
    }
}

// 检查数据库文件是否有新版本
- (void)checkDatabaseVersion:(FMDatabase *)database orginName:(NSString *)orginName targetName:(NSString *)targetName version:(float)version publicDB:(BOOL)publicDB
{
    FMResultSet *rs = [database executeQuery:@"SELECT value FROM config WHERE key = 'database_version'"];
    if ([rs next]) {
        NSDictionary *dic = [rs resultDictionary];
        float dbVersion = [[dic objectForKey:@"value"] floatValue];
        if (version != dbVersion) { // 有新版本，删除原来的数据库文件
            BOOL success;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:targetName];
            success = [fileManager fileExistsAtPath:writableDBPath];
            if (success) {
                [fileManager removeItemAtPath:writableDBPath error:&error];
                if (success) {
                    [self checkDatabase:orginName targetName:targetName version:version publicDB:publicDB];
                } else {
                    NSLog(@"%s %d '%@'.", __FUNCTION__, __LINE__, [error localizedDescription]);
                }
            }
        }
    }
}

@end
