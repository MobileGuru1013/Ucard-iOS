//
//  PasswordNicknameBaseViewController.h
//  Ucard
//
//  Created by Conner Wu on 15-4-13.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityButton.h"

@interface PasswordNicknameBaseViewController : UIViewController
{
    UILabel *_titleLabel;
    UITextField *_textField;
    ActivityButton *_submitButton;
}

@property (nonatomic, strong) void (^goBackBlock) ();

- (id)init:(NSString *)placeholder;

@end
