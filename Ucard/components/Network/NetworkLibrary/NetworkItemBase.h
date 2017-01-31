//
//  NetworkItemBase.h
//
//
//  Created by WuLeilei.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkOperation.h"

typedef void (^CompletedBlock) (id result, BOOL succ);
typedef void (^UploadProgressBlock) (float progress);

@interface NetworkItemBase : NSObject
{
    NWFlag _flag;
    NSString *_path;
    NSDictionary *_params;
    NSArray *_files;
    UIView *_loadingSuperView;
    BOOL _showLoading;
    BOOL _showError;
}

@property (nonatomic, strong) NSArray *directFiles;
@property (nonatomic, assign) BOOL showLoading;

- (id)initWithLoadingSuperView:(UIView *)view;
- (void)startGetLocation;
- (void)startGet;
- (void)startPost;
- (void)startRequest;
- (void)privateRequestCompleted:(id)result;
- (void)requestCompleted:(id)result succ:(BOOL)succ;
- (void)completion:(CompletedBlock)completion;
- (void)uploadProgress:(UploadProgressBlock)progressBlock;
- (void)cancelOperation;

@end
