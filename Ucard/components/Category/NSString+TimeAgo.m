//
//  NSString+TimeAgo.m
//  Ucard
//
//  Created by WuLeilei on 15/5/11.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "NSString+TimeAgo.h"
#import "NSDate+TimeAgo.h"

@implementation NSString (TimeAgo)

- (NSString *)timeAgo
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self];
    
    //设置源日期时区
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //设置转换后的目标日期时区
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    return [destinationDateNow timeAgo];
}

@end
