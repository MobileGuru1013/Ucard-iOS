//
//  ReceiveDetailHeaderView.h
//  Ucard
//
//  Created by Conner Wu on 15/5/9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveDetailModel.h"

@interface ReceiveDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) void (^publicBlock) (BOOL public);

+ (CGFloat)height;
- (void)setContent:(ReceiveDetailModel *)cardModel;

@end
