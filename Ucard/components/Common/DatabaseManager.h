//
//  DatabaseManager.h
//  ProjectARC
//
//  Created by WuLeilei on 15-2-2.
//  Copyright (c) 2015年 WuLeilei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseManager : NSObject

@property (nonatomic, strong) FMDatabase *userDB;
@property (nonatomic, strong) FMDatabase *publicDB;

+ (instancetype)shareInstance;
- (void)checkUserDatabase:(NSString *)userId;

@end
