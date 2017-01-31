//
//  CommonBackViewController.m
//  Teacher
//
//  Created by WuLeilei on 15/1/17.
//  Copyright (c) 2015年 WuLeilei. All rights reserved.
//

#import "CommonBackViewController.h"

@interface CommonBackViewController ()

@end

@implementation CommonBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *addCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCommentButton setFrame:CGRectMake(0, 0, 25, 25)];
    [addCommentButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [addCommentButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addCommentButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)setRightButton:(UIImage *)image target:(id)target selector:(SEL)selector
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:selector];
    self.navigationItem.rightBarButtonItem.tintColor = kGreenColor;
}

- (void)setRightButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}


- (void)goBack
{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        if (self.goBackBlock) {
            self.goBackBlock();
        }
    }
}

@end
