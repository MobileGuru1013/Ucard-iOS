//
//  NicknameViewController.m
//  Ucard
//
//  Created by Conner Wu on 15-4-13.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "NicknameViewController.h"

@interface NicknameViewController ()

@end

@implementation NicknameViewController

- (id)init
{
    if (self = [super init:NSLocalizedString(@"localized002", nil)]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.text = NSLocalizedString(@"localized017", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submit
{
    NSString *text = _textField.text;
    if (text && text.length > 0) {
        [_textField resignFirstResponder];
        if (self.submitBlock) {
            self.submitBlock(_textField.text, _submitButton);
        }
    }
}

@end
