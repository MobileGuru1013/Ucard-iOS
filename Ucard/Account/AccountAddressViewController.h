//
//  AccountAddressViewController.h
//  Ucard
//
//  Created by WuLeilei on 15/5/2.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommonBackViewController.h"

@interface AccountAddressViewController : CommonBackViewController

@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) void (^submitBlock) (NSString *text);

@end
