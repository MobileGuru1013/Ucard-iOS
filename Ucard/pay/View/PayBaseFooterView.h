//
//  PayBaseFooterView.h
//  Ucard
//
//  Created by WuLeilei on 15/5/27.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPayFooterHeight 110

@interface PayBaseFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) void (^submitBlock) ();

- (void)submit;

@end
