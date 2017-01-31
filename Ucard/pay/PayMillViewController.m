//
//  PayMillViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/21.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PayMillViewController.h"
#import <PayMillSDK/PMSDK.h>
#import "UIView+Frame.h"

@interface PayMillViewController ()
{
    UITextField *_accTextField;
    UITextField *_numberTextField;
    UITextField *_yearTextField;
    UITextField *_cvvTextField;
    NSInteger _retry;
}
@end

@implementation PayMillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _retry = 0;
    [self initPaymill];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initPaymill
{
    [[Singleton shareInstance] startLoadingInView:self.view];
    
    __weak typeof(self) weakself = self;
    [PMManager initWithTestMode:kPaymillTestModel merchantPublicKey:kPaymillPublicKey newDeviceId:nil init:^(BOOL success, NSError *error) {
        [[Singleton shareInstance] stopLoading];
        if (success) {
            [weakself showView];
        } else {
            if (_retry < 3) {
                [weakself initPaymill];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:error.description
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                
                [weakself goBack];
            }
            _retry++;
        }
    }];
}

- (void)showView
{
    UIImageView *line0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 10, kScreenWidth, 0.5)];
    line0.backgroundColor = [UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1];
    [self.view addSubview:line0];
    
    _accTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line0.frame), kScreenWidth, 44)];
    _accTextField.font = [UIFont systemFontOfSize:15];
    _accTextField.backgroundColor = [UIColor whiteColor];
    _accTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5, CGRectGetHeight(_accTextField.frame))];
    _accTextField.leftViewMode = UITextFieldViewModeAlways;
    _accTextField.placeholder = NSLocalizedString(@"localized145", nil);
    [self.view addSubview:_accTextField];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_accTextField.frame), kScreenWidth, 0.5)];
    line1.backgroundColor = line0.backgroundColor;
    [self.view addSubview:line1];
    
    _numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), kScreenWidth, 44)];
    _numberTextField.font = [UIFont systemFontOfSize:15];
    _numberTextField.backgroundColor = [UIColor whiteColor];
    _numberTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5, CGRectGetHeight(_numberTextField.frame))];
    _numberTextField.leftViewMode = UITextFieldViewModeAlways;
    _numberTextField.placeholder = NSLocalizedString(@"localized146", nil);
    [self.view addSubview:_numberTextField];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:line1.frame];
    [line2 setFrameOriginY:CGRectGetMaxY(_numberTextField.frame)];
    line2.backgroundColor = line1.backgroundColor;
    [self.view addSubview:line2];
    
    _yearTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), kScreenWidth / 2.0, 44)];
    _yearTextField.font = _yearTextField.font;
    _yearTextField.backgroundColor = [UIColor whiteColor];
    _yearTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5, CGRectGetHeight(_numberTextField.frame))];
    _yearTextField.leftViewMode = UITextFieldViewModeAlways;
    _yearTextField.placeholder = NSLocalizedString(@"localized147", nil);
    [self.view addSubview:_yearTextField];
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0, CGRectGetMaxY(line2.frame), 0.5, 44)];
    line3.backgroundColor = line1.backgroundColor;
    [self.view insertSubview:line3 aboveSubview:_yearTextField];
    
    _cvvTextField = [[UITextField alloc] initWithFrame:_yearTextField.frame];
    [_cvvTextField setFrameOriginX:kScreenWidth / 2.0];
    _cvvTextField.font = _yearTextField.font;
    _cvvTextField.backgroundColor = [UIColor whiteColor];
    _cvvTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5, CGRectGetHeight(_numberTextField.frame))];
    _cvvTextField.leftViewMode = UITextFieldViewModeAlways;
    _cvvTextField.placeholder = NSLocalizedString(@"localized148", nil);
    [self.view insertSubview:_cvvTextField belowSubview:line3];
    
    UIImageView *line4  = [[UIImageView alloc] initWithFrame:line2.frame];
    [line4 setFrameOriginY:CGRectGetMaxY(_cvvTextField.frame)];
    line4.backgroundColor = line1.backgroundColor;
    [self.view addSubview:line4];
    
    [self setRightButtonWithTitle:NSLocalizedString(@"localized012", nil) target:self selector:@selector(submitCard)];
}

- (void)submitCard
{
    NSString *acc = _accTextField.text;
    NSString *number = _numberTextField.text;
    NSString *year = _yearTextField.text;
    NSString *cvv = _cvvTextField.text;
    
    NSArray *yearArray = [year componentsSeparatedByString:@"/"];
    NSString *tips;
    if (acc.length == 0) {
        tips = NSLocalizedString(@"localized041", nil);
    } else if (number.length == 0) {
        tips = NSLocalizedString(@"localized042", nil);
    } else if (year == 0) {
        tips = NSLocalizedString(@"localized043", nil);
    } else if (cvv.length == 0) {
        tips = NSLocalizedString(@"localized044", nil);
    } else if (number.length != 16) {
        tips = NSLocalizedString(@"localized045", nil);
    } else if (year.length != 5 || yearArray.count != 2) {
        tips = NSLocalizedString(@"localized046", nil);
    } else if (cvv.length != 3) {
        tips = NSLocalizedString(@"localized047", nil);
    }
    if (tips) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:tips
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSString *month = [[yearArray firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *yearString = [[yearArray lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [_accTextField resignFirstResponder];
    [_numberTextField resignFirstResponder];
    [_yearTextField resignFirstResponder];
    [_cvvTextField resignFirstResponder];
    
    [[Singleton shareInstance] startLoadingInView:self.view];
    
    __weak typeof(self) weakself = self;
    NSError *error;
    PMPaymentParams *params;
    id paymentMethod = [PMFactory genCardPaymentWithAccHolder:acc
                                                   cardNumber:number
                                                  expiryMonth:month
                                                   expiryYear:[NSString stringWithFormat:@"20%@", yearString]
                                                 verification:cvv
                                                        error:&error];
    
    if (!error) {
        NSString *productDescription = [NSString stringWithFormat:@"Ucard-%@-%@-%@", [Singleton shareInstance].uid, _orderId, [Singleton shareInstance].cardModel.remoteCardId];
        NSString *currency = self.unit;
        if ([Constants isCNLanguage]) {
            if ([self.unit isEqualToString:@"欧元"]) {
                currency = @"EUR";
            } else if ([self.unit isEqualToString:@"英镑"]) {
                currency = @"GBP";
            }
        }
        params = [PMFactory genPaymentParamsWithCurrency:currency amount:self.price * 100 description:productDescription error:&error];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:error.description
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    if (!error) {
        [PMManager transactionWithMethod:paymentMethod parameters:params consumable:TRUE success:^(PMTransaction *transaction) {
            [[Singleton shareInstance] stopLoading];
            
            if (weakself.finishedBlock) {
                weakself.finishedBlock(transaction.id);
            }
        }  failure:^(NSError *error) {
            [[Singleton shareInstance] stopLoading];
            NSLog(@"%@", error);
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:error.description
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
