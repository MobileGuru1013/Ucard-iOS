//
//  SigninPasswordTableViewCell.h
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SigninUserTableViewCell.h"

@interface SigninPasswordTableViewCell : SigninUserTableViewCell

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) void (^passwordBlock) ();

@end



