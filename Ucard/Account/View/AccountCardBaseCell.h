//
//  AccountCardBaseCell.h
//  Ucard
//
//  Created by Conner Wu on 15/5/7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCardBaseCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIImageView *photoImageView1;
@property (nonatomic, strong) UIImageView *photoImageView2;

@property (nonatomic, strong) UIImageView *photoImageView3;


+ (CGFloat)height;

@end
