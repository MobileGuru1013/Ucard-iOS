//
//  SimpleNetwork.h
//  ProjectARC
//
//  Created by WuLeilei on 15-2-2.
//  Copyright (c) 2015年 WuLeilei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SimpleCompletedBlock) (id result);

@interface SimpleNetwork : NSObject

- (void)startRequests:(NSString *)urlString;
- (void)completion:(SimpleCompletedBlock)completion;

@end
