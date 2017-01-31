//
//  PaySuccViewController.m
//  Ucard
//
//  Created by Conner Wu on 15/5/5.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PaySuccViewController.h"
#import "AppDelegate.h"

@interface PaySuccViewController ()

@end

@implementation PaySuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"pay-complete-bg"];
    [self.view addSubview:imageView];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 105) / 2, 30, 105, 25)];
    logo.image = [UIImage imageNamed:@"pay-complete-logo"];
    [self.view addSubview:logo];
    
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 45) / 2, CGRectGetMaxY(logo.frame) + 50, 45, 45)];
    right.image = [UIImage imageNamed:@"pay-complete-icon"];
    [self.view addSubview:right];
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(right.frame) + 30, kScreenWidth - 40 * 2, 80)];
    tips.textColor = [UIColor whiteColor];
    tips.font = [UIFont systemFontOfSize:20];
    tips.numberOfLines = 0;
    tips.text = NSLocalizedString(@"localized048", nil);
    [self.view addSubview:tips];
    
    UILabel *order = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(tips.frame), CGRectGetMaxY(tips.frame) + 10, CGRectGetWidth(tips.frame), 80)];
    order.textColor = [UIColor whiteColor];
    order.font = [UIFont systemFontOfSize:15];
    order.numberOfLines = 0;
    order.text = [NSString stringWithFormat:@"%@%@\n%@", NSLocalizedString(@"localized049", nil), _orderId, NSLocalizedString(@"localized050", nil)];
    [self.view addSubview:order];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMinX(tips.frame), kScreenHeight - 40 - 40, CGRectGetWidth(tips.frame), 40);
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"localized051", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [Singleton shareInstance].cardModel = nil;
    [DraftCardModel deleteData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadSendNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToRoot
{
    [[AppDelegate shareDelegate] reloadCardViewController];
}

@end
