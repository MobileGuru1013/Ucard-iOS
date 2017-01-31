//
//  NetworkItemBase.m
//
//
//  Created by WuLeilei.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import "NetworkItemBase.h"
#import "AppDelegate.h"

typedef enum {
    post = 1,
    get = 2
} HttpMethodType;

@interface NetworkItemBase ()
{
    BOOL _isCancel;
    HttpMethodType _methodType;
    NSUInteger _retryCount;
    CompletedBlock _completedBlock;
    UploadProgressBlock _uploadProgressBlock;
    NetworkOperation *_networkOperation;
}
@end

@implementation NetworkItemBase

@synthesize showLoading = _showLoading;

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (id)init
{
    self = [self initWithLoadingSuperView:((AppDelegate *)[UIApplication sharedApplication].delegate).window];
    return self;
}

- (id)initWithLoadingSuperView:(UIView *)view
{
    self = [super init];
    if (self) {
        _retryCount = 0;
        _showLoading = YES;
        _showError = YES;
        _loadingSuperView = view;
    }
    return self;
}

- (void)cancelOperation
{
    if (_networkOperation) {
        _isCancel = YES;
        [_networkOperation cancelOperation];
    }
}

#pragma mark GET LOCATION Method

- (void)startGetLocation
{
    
    _retryCount++;
    
    BOOL alertError = _retryCount < kHttpRetryCount ? NO : _showError;
    
    NetworkOperation *networkOperation = [[NetworkOperation alloc] init];
    networkOperation.flag = _flag;
    networkOperation.path = _path;
    networkOperation.params = _params;
    networkOperation.files = _files;
    networkOperation.loadingSuperView = _loadingSuperView;
    networkOperation.showLoading = _showLoading;
    networkOperation.showError = alertError;
    networkOperation.completion = ^(id result) {
        [self privateRequestCompleted:result];
    };
    networkOperation.uploadProgress = ^(float progress) {
        if (_uploadProgressBlock) {
            _uploadProgressBlock(progress);
        }
    };
    
    [networkOperation getDataLocation];
    
    _networkOperation = networkOperation;
}


#pragma mark GET Method

- (void)startGet
{
    [self sendRequest:get];
}

#pragma mark POST Method

- (void)startPost
{
    if (_directFiles && _directFiles.count > 0) {
        _files = _directFiles;
    } else {
        // 保存image
        NSMutableArray *fileArray;
        if (_files && _files.count > 0) {
            fileArray = [NSMutableArray array];
            for (unsigned int i = 0; i < _files.count; i++) {
                NSDictionary *dic = [_files objectAtIndex:i];
                UIImage *image = [self scaleImage:[dic objectForKey:@"image"] toSize:CGSizeMake(800, 600)];
                
                NSData *data;
                if (UIImagePNGRepresentation(image) == nil) {
                    data = UIImageJPEGRepresentation(image, 1.0);
                } else {
                    data = UIImagePNGRepresentation(image);
                }
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString *cachePath = [paths objectAtIndex:0];
                NSString *filePath = [cachePath stringByAppendingFormat:@"/upload-file-%i.jpg", i];
                
                [UIImageJPEGRepresentation(image, 0.6) writeToFile:filePath atomically:YES];
                
                NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [newDic setObject:filePath forKey:@"path"];
                [fileArray addObject:newDic];
            }
        }
        _files = fileArray;
    }
    
    [self sendRequest:post];
}

#pragma mark Request Method

- (void)sendRequest:(HttpMethodType)type
{
    _retryCount++;
    _methodType = type;
    
    BOOL alertError = _retryCount < kHttpRetryCount ? NO : _showError;
    
    NetworkOperation *networkOperation = [[NetworkOperation alloc] init];
    networkOperation.flag = _flag;
    networkOperation.path = _path;
    networkOperation.params = _params;
    networkOperation.files = _files;
    networkOperation.loadingSuperView = _loadingSuperView;
    networkOperation.showLoading = _showLoading;
    networkOperation.showError = alertError;
    networkOperation.completion = ^(id result) {
        [self privateRequestCompleted:result];
    };
    networkOperation.uploadProgress = ^(float progress) {
        if (_uploadProgressBlock) {
            _uploadProgressBlock(progress);
        }
    };
    
    if (type == get) {
        [networkOperation getData];
    } else {
        [networkOperation postData];
    }
    
    _networkOperation = networkOperation;
}

// private
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIImage *newImage;
    
    int h = image.size.height;
    int w = image.size.width;
    
    if (h <= size.height && w <= size.width) {
        newImage = image;
    } else {
        float destWith = 0.0f;
        float destHeight = 0.0f;
        
        float suoFang = (float)w/h;
        float suo = (float)h/w;
        if (w > h) {
            destWith = (float)size.width;
            destHeight = size.width * suo;
        } else {
            destHeight = (float)size.height;
            destWith = size.height * suoFang;
        }
        
        CGSize itemSize = CGSizeMake(destWith, destHeight);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0, 0, destWith, destHeight);
        [image drawInRect:imageRect];
        UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        newImage = newImg;
    }
    return newImage;
}

- (void)privateRequestCompleted:(id)result
{
    BOOL flag = NO;
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicResult = (NSDictionary *)result;
        NSArray *allKeys = [dicResult allKeys];
        if ([allKeys containsObject:kHttpReturnCodeKey]) {
            id code = [result objectForKey:kHttpReturnCodeKey];
            if ([code isKindOfClass:[NSString class]]) {
                code = [NSNumber numberWithInteger:[code integerValue]];
            }
            if ([kHttpSuccCode containsObject:code]) {
                flag = YES;
            }
        }
    } else if([result isKindOfClass:[NSArray class]]){
        NSArray *arr = (NSArray *) result;
        if (arr) {
            flag = YES;
            
        }
    }
    [self requestCompleted:result succ:flag];
}

- (void)uploadProgress:(UploadProgressBlock)progressBlock
{
    _uploadProgressBlock = progressBlock;
}

// 定义回调
- (void)completion:(CompletedBlock)completion
{
    _completedBlock = completion;
}

// 回调
- (void)requestCompleted:(id)result succ:(BOOL)succ
{
    _networkOperation = nil;
    
    if (!succ) {
        if (_retryCount < kHttpRetryCount && !_isCancel) {
            [self sendRequest:_methodType];
            return;
        }
    }
    
    if (_completedBlock) {
        _completedBlock(result, succ);
    }
}

// 虚函数
- (void)startRequest
{
    
}

@end
