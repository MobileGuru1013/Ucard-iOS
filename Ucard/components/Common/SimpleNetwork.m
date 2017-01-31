//
//  SimpleNetwork.m
//  ProjectARC
//
//  Created by WuLeilei on 15-2-2.
//  Copyright (c) 2015年 WuLeilei. All rights reserved.
//

#import "SimpleNetwork.h"

@interface SimpleNetwork ()
{
    SimpleCompletedBlock _completedBlock;
}
@end

@implementation SimpleNetwork

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)startRequests:(NSString *)urlString
{
    NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"请求地址：%@", urlString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30.0f];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"request error:\r\n%@", error);
    }
    NSString *resultString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    [self performSelectorOnMainThread:@selector(requestComplete:) withObject:resultString waitUntilDone:YES];
}

- (void)requestComplete:(NSString *)string
{
    NSDictionary *result = string ? [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil] : nil;
    
    if (_completedBlock) {
        _completedBlock(result);
    }
}

// 定义回调
- (void)completion:(SimpleCompletedBlock)completion
{
    _completedBlock = completion;
}

@end
