//
//  SigninPasswordTableViewCell.m
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SigninPasswordTableViewCell.h"

@implementation SigninPasswordTableViewCell
- (void)resetPassword
{
    if (self.passwordBlock) {
        self.passwordBlock();
    }
}

@end
