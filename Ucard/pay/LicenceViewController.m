//
//  LicenceViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "LicenceViewController.h"

@interface LicenceViewController ()

@end

@implementation LicenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRightButton];
    self.title = NSLocalizedString(@"localized040", nil);
    
    [self loadHTML:@"terms-and-conditions-en"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
