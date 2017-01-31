//
//  TextFieldTableViewController.h
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommonBackViewController.h"

@interface TextFieldTableViewController : CommonBackViewController
{
    UITextField *_textField;
}

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) void (^submitBlock) (NSString *text);

@end
