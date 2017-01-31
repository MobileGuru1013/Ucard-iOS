//
//  AccountHeaderCell.h
//  Ucard
//
//  Created by Conner Wu on 15/5/7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountHeaderCell : UITableViewCell

@property (nonatomic, strong) void (^editProfileBlock) (UIButton *button);
@property (nonatomic, strong) void (^showSettingsBlock) (UIButton *button);
@property (nonatomic, strong) void (^showSearchCardBlock) ();

+ (CGFloat)height;

@end
