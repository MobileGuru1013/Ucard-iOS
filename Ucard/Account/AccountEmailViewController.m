//
//  AccountEmailViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/2.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountEmailViewController.h"
#import "SVProgressHUD.h"

@interface AccountEmailViewController ()

@end

@implementation AccountEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightButtonWithTitle:NSLocalizedString(@"localized067", nil) target:self selector:@selector(submit)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submit
{
    NSString *email = _textField.text;
    if (!email || email.length == 0) {
        [Constants showTipsMessage:NSLocalizedString(@"localized185", nil)];
        return;
    }
    
    NSDictionary *dic = [[Singleton shareInstance].user toDictionary];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dic error:nil];
    model.email = email;
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized083", nil)];
            [Singleton shareInstance].user = model;
            
            if (weakself.submitBlock) {
                weakself.submitBlock(nil);
            }
            
            [weakself goBack];
        }
    }];
    [request submitUserInfo:model];
}

- (void)goBack
{
    [super goBack];
}

@end
