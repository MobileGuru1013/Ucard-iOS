//
//  AboutViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/2.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideRightButton];
    [self loadHTML:[Constants isCNLanguage] ? @"about-cn" : @"about-en"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
