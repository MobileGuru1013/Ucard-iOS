//
//  NetworkOperation.h
//
//
//  Created by WuLeilei.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHttpSuccCode @[@1000, @27, @32]
#define kHttpReturnCodeKey @"code"
#define kHttpRetryCount 3

typedef enum {
    NWFlagNotShowError = 101,
} NWFlag;

@interface NetworkOperation : NSObject

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSArray *files;
@property (nonatomic, strong) UIView *loadingSuperView;
@property (nonatomic, assign) BOOL showLoading;
@property (nonatomic, assign) BOOL showError;
@property (nonatomic, assign) NWFlag flag;
@property (nonatomic, strong) void (^completion) (id result);
@property (nonatomic, strong) void (^uploadProgress) (float progress);

- (void)getData;
- (void)postData;

- (void)getDataLocation;
- (void)cancelOperation;

@end
