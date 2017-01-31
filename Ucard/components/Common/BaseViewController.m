//
//  BaseViewController.m
//  Parents
//
//  Created by WuLeilei on 14/12/16.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0];
    [self showNavLogo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)showNavLogo
{
    
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2-10, 20)];
    label.text=NSLocalizedString(@"localized234",nil);
    label.font=[UIFont fontWithName:@"System" size:20];
    label.textColor=[UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:102.0/255.0 green:201.0/255.0 blue:144/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 20, 20)];
    [button addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
- (void)showNotifocations
{
    
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2-10, 20)];
    label.text=NSLocalizedString(@"localized235",nil);
    label.font=[UIFont fontWithName:@"System" size:20];
    label.textColor=[UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:102.0/255.0 green:201.0/255.0 blue:144/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void) hideNavLogo
{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = nil;
}

-(void) hideRightButton {
    self.navigationItem.rightBarButtonItem = nil;
}
-(void) hideBackLogo{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
