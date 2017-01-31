//
//  PayMillViewController.h
//  Ucard
//
//  Created by WuLeilei on 15/5/21.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommonBackViewController.h"

@interface PayMillViewController : CommonBackViewController

@property (nonatomic, strong) void (^finishedBlock) (NSString *swiftId);
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, assign) float price;

@end
