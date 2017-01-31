//
//  Networking.m
//
//
//  Created by WuLeilei.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import "NetworkOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "Singleton.h"
#import "AFURLSessionManager.h"

@interface NetworkOperation ()
{
    BOOL _showError;
    BOOL _isCancel;
    AFHTTPRequestOperation *_requestOperation;
}

@end

@implementation NetworkOperation

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)cancelOperation
{
    if (_requestOperation) {
        _isCancel = YES;
        [_requestOperation cancel];
    }
}

// GET LOCATION DATA
- (void)getDataLocation
{
    [self startRequestLocationHost:@"GET"];
}


// GET
- (void)getData
{
    [self startRequest:@"GET"];
}

// POST
- (void)postData
{
    [self startRequest:@"POST"];
}

// send request to location api
- (void)startRequestLocationHost:(NSString *)method
{
    // show loading
    if (self.showLoading) {
        [[Singleton shareInstance] startLoadingInView:self.loadingSuperView];
    }
    
    NSString *urlString = @"http://ucardapi.southeastasia.cloudapp.azure.com/api/city?countryCode=IE";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer.timeoutInterval = (_files && _files.count > 0) ? 600 : 60;
    if ([method isEqualToString:@"GET"]) {
        NSMutableString *p = [NSMutableString stringWithFormat:@"%@?", urlString];
        for (NSString *key in _params.allKeys) {
            [p appendFormat:@"%@=%@&", key, [_params objectForKey:key]];
        }
        NSLog(@"%@", p);
        
        [manager GET:urlString parameters:_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self requestCompleted:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败: %@", error);
            [self requestCompleted:operation];
        }];
    }
}

// send request
- (void)startRequest:(NSString *)method
{
    // show loading
    if (self.showLoading) {
        [[Singleton shareInstance] startLoadingInView:self.loadingSuperView];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kApiURL, _path];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = (_files && _files.count > 0) ? 600 : 60;
    if ([method isEqualToString:@"GET"]) {
        NSMutableString *p = [NSMutableString stringWithFormat:@"%@?", urlString];
        for (NSString *key in _params.allKeys) {
            [p appendFormat:@"%@=%@&", key, [_params objectForKey:key]];
        }
        NSLog(@"%@", p);
        
        [manager GET:urlString parameters:_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self requestCompleted:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败: %@", error);
            [self requestCompleted:operation];
        }];
    } else {
        NSLog(@"\n请求地址：%@\n提交数据：%@", urlString, _params);
        
        _requestOperation = [manager POST:urlString parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            // 上传文件
            if (_files && _files.count > 0) {
                NSLog(@"上传文件：%@", _files);
                for (NSDictionary *fileDic in _files) {
                    NSError *error;
                    NSString *filePath = [fileDic objectForKey:@"path"];
                    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
                    BOOL flag = [formData appendPartWithFileURL:fileURL name:[fileDic objectForKey:@"name"] error:&error];
                    if (!flag) {
                        NSLog(@"%@", error);
                    }
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self requestCompleted:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败: %@", error);
            [self requestCompleted:operation];
        }];
        
        if (self.uploadProgress) {
            [_requestOperation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                                        long long totalBytesWritten,
                                                        long long totalBytesExpectedToWrite) {
                float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
                NSLog(@"upload: %f %f", progress, totalBytesExpectedToWrite / (1024.0 * 1024.0));
                self.uploadProgress(progress);
            }];
            [_requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                float progress = (float)totalBytesRead / (float)totalBytesExpectedToRead;
                NSLog(@"download: %f %f", progress, totalBytesExpectedToRead / (1024.0 * 1024.0));
            }];
        }
    }
}

// call back
- (void)requestCompleted:(AFHTTPRequestOperation *)completedOperation
{
    _requestOperation = nil;
    
    [[Singleton shareInstance] stopLoading];
    
    id result = completedOperation.responseObject;
    
    NSLog(@"返回数据：%@", result ? result : completedOperation.responseString);
    
    if (!_isCancel) {
        if (completedOperation.response.statusCode == 0) {
            NSString *errorDescription = [completedOperation.error.userInfo objectForKey:@"NSLocalizedDescription"];
            [self showMessage:errorDescription ? [errorDescription substringToIndex:errorDescription.length - 1] : NSLocalizedString(@"localized141", nil)];
        } else if (completedOperation.response.statusCode == 200) {
            if (result) {
                @try {
                    id code = [result objectForKey:kHttpReturnCodeKey];
                    if ([code isKindOfClass:[NSString class]]) {
                        code = [NSNumber numberWithInteger:[code integerValue]];
                    }
                    if (![kHttpSuccCode containsObject:code] && _flag != NWFlagNotShowError) {
                        NSInteger cd = [code integerValue];
                        if (cd != 38) {
                            NSString *msg = [self getMessageByCode:cd];
                            msg = msg ? msg : [result objectForKey:@"message"];
                            [self showMessage:msg.length > 0 ? msg : NSLocalizedString(@"localized142", nil)];
                            //                        return;
                        }
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            } else {
                [self showMessage:NSLocalizedString(@"localized143", nil)];
            }
        } else {
            [self showMessage:NSLocalizedString(@"localized144", nil)];
        }
    }
    
    if (self.completion) {
        self.completion(result);
    }
}

// show message
- (void)showMessage:(NSString *)message
{
    if (self.showError) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (NSString *)getMessageByCode:(NSInteger)code
{
    NSString *msg;
    
    switch (code) {
        case 1:
            msg = NSLocalizedString(@"localized150", nil);
            break;
            
        case 2:
            msg = NSLocalizedString(@"localized151", nil);
            break;
            
        case 3:
            msg = NSLocalizedString(@"localized152", nil);
            break;
            
        case 4:
            msg = NSLocalizedString(@"localized153", nil);
            break;
            
        case 9:
            msg = NSLocalizedString(@"localized154", nil);
            break;
            
        case 10:
            msg = NSLocalizedString(@"localized155", nil);
            break;
            
        case 15:
            msg = NSLocalizedString(@"localized156", nil);
            break;
            
        case 16:
            msg = NSLocalizedString(@"localized157", nil);
            break;
            
        case 11:
            msg = NSLocalizedString(@"localized158", nil);
            break;
            
        case 12:
            msg = NSLocalizedString(@"localized159", nil);
            break;
            
        case 13:
            msg = NSLocalizedString(@"localized160", nil);
            break;
            
        case 17:
            msg = NSLocalizedString(@"localized161", nil);
            break;
            
        case 20:
            msg = NSLocalizedString(@"localized162", nil);
            break;
            
        case 14:
            msg = NSLocalizedString(@"localized163", nil);
            break;
            
        case 18:
            msg = NSLocalizedString(@"localized164", nil);
            break;
            
        case 21:
            msg = NSLocalizedString(@"localized165", nil);
            break;
            
        case 22:
            msg = NSLocalizedString(@"localized166", nil);
            break;
            
        case 23:
            msg = NSLocalizedString(@"localized167", nil);
            break;
            
        case 24:
            msg = NSLocalizedString(@"localized168", nil);
            break;
            
        case 6:
            msg = NSLocalizedString(@"localized169", nil);
            break;
            
        case 7:
            msg = NSLocalizedString(@"localized170", nil);
            break;
            
        case 5:
            msg = NSLocalizedString(@"localized171", nil);
            break;
            
        case 25:
            msg = NSLocalizedString(@"localized172", nil);
            break;
            
        case 26:
            msg = NSLocalizedString(@"localized173", nil);
            break;
            
        case 27:
            msg = NSLocalizedString(@"localized174", nil);
            break;
            
        case 32:
            msg = NSLocalizedString(@"localized175", nil);
            break;
            
        case 28:
            msg = NSLocalizedString(@"localized176", nil);
            break;
            
        case 29:
            msg = NSLocalizedString(@"localized176", nil);
            break;
            
        case 30:
            msg = NSLocalizedString(@"localized177", nil);
            break;
            
        case 45:
            msg = NSLocalizedString(@"localized178", nil);
            break;
            
        case 31:
            msg = NSLocalizedString(@"localized176", nil);
            break;
            
        case 33:
            msg = NSLocalizedString(@"localized179", nil);
            break;
            
        case 34:
            msg = NSLocalizedString(@"localized179", nil);
            break;
            
        case 36:
            msg = NSLocalizedString(@"localized179", nil);
            break;
            
        case 38:
            msg = NSLocalizedString(@"localized179", nil);
            break;
            
        case 46:
            msg = NSLocalizedString(@"localized180", nil);
            break;
            
        case 48:
            msg = NSLocalizedString(@"localized181", nil);
            break;
            
        case 49:
            msg = NSLocalizedString(@"localized182", nil);
            break;
            
        case 50:
            msg = NSLocalizedString(@"localized176", nil);
            break;
            
        case 39:
            msg = NSLocalizedString(@"localized179", nil);
            break;
            
        case 40:
            msg = NSLocalizedString(@"localized183", nil);
            break;
            
        case 41:
            msg = NSLocalizedString(@"localized176", nil);
            break;
            
        case 42:
            msg = NSLocalizedString(@"localized179", nil);
            break;
            
        case 43:
            msg = NSLocalizedString(@"localized183", nil);
            break;
            
        case 44:
            msg = NSLocalizedString(@"localized184", nil);
            break;
            
        case 47:
            msg = NSLocalizedString(@"localized184", nil);
            break;
            
        default:
            break;
    }
    
    return msg;
}

@end
