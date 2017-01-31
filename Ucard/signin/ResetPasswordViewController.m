//
//  ResetPasswordViewController.m
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (id)init
{
    if (self = [super init:NSLocalizedString(@"localized001", nil)]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.text = NSLocalizedString(@"localized016", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submit
{
    NSString *text = _textField.text;
    if (!text || text.length == 0) {
        [Constants showTipsMessage:NSLocalizedString(@"localized185", nil)];
        return;
    }
    [_textField resignFirstResponder];
    
    [_submitButton startLoading];
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        [_submitButton stopLoading];
        
        if (succ) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"localized015", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
            if (weakself.goBackBlock) {
                weakself.goBackBlock();
            }
        }
    }];
    [request forgetPassword:text];
}

@end
