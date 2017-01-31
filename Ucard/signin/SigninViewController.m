//
//  SigninViewController.m
//  Ucard
//
//  Created by Conner Wu on 15-3-19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SigninViewController.h"
#import "SigninUserTableViewCell.h"
#import "SigninPasswordTableViewCell.h"
#import "ResetPasswordViewController.h"
#import "UserModel.h"
#import "UIView+Frame.h"
#import "UIColor+CustomColors.h"
#import "SignupViewController.h"


@interface SigninViewController () <UITextFieldDelegate>
{
    ResetPasswordViewController *_resetPasswordViewController;
    SignupViewController *_signupViewController;
}
@end
bool isSignUp;
@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    isSignUp = FALSE;
    _titleLabel.text = NSLocalizedString(@"localized008", nil);
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 15, 50, 50);
    [backButton setImage:[UIImage imageNamed:@"public-back-gray"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(showSignup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    NSString *email = @"";
    NSArray *accountArray = [UserModel getAccount];
    if (accountArray && accountArray.count == 3) {
        NSString *user = accountArray[0];
        NSString *type = accountArray[2];
        if ([type isEqualToString:@"email"]) {
            email = user;
        }
    }
    
    NSArray *array = @[@{@"key": @"name", @"placeholder": NSLocalizedString(@"localized001", nil), @"value": email},
                       @{@"key": @"password", @"placeholder": NSLocalizedString(@"localized003", nil)}];
    
    _dataArray = [KeyPlaceholderValueModel arrayOfModelsFromDictionaries:array];
    
    [super createOtherView:NSLocalizedString(@"localized008", nil) sel:@selector(doSignin) signup:NO];
    
    [_tableView registerClass:[SigninUserTableViewCell class] forCellReuseIdentifier:@"SigninUserTableViewCell"];
    [_tableView registerClass:[SigninPasswordTableViewCell class] forCellReuseIdentifier:@"SigninPasswordTableViewCell"];
    
    _tipsLabel.text = NSLocalizedString(@"localized009", nil);
    [_tipsButton setTitle:NSLocalizedString(@"localized010", nil) forState:UIControlStateNormal];
    [_tipsButton addTarget:self action:@selector(showSignup) forControlEvents:UIControlEventTouchUpInside];
    
    int lblWidth;
    int bttWidth = 70;
    if (kR55) {
        bttWidth = 60;
    }
    
    int height = _tipsLabel.frame.size.height;
    [_tipsLabel sizeToFit];
    lblWidth = _tipsLabel.frame.size.width;

    int margin = (viewpoop.frame.size.width - lblWidth - bttWidth - 5)/ 2;
    CGRect frame = _tipsLabel.frame;
    frame.origin.x = margin;
    frame.size.height = height;
    _tipsLabel.frame = frame;
    frame = _tipsButton.frame;
    frame.origin.x = CGRectGetMaxX(_tipsLabel.frame) + 5;
    frame.size.width = bttWidth;
    _tipsButton.frame = frame;
    int forgotWidth = 130;
    if (kR55) {
        forgotWidth = 130;
    }
    
     _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(kScreenWidth - (kR35 ? 10 :20) - forgotWidth,CGRectGetMaxY(_tableView.frame) + 5 , forgotWidth, 44 - 5 * 2);
    
     [_button setTitleColor:kWhiteColor forState:UIControlStateNormal];
     [_button setTitle:NSLocalizedString(@"localized011", nil) forState:UIControlStateNormal];
     [_button addTarget:self action:@selector(showResetPassword) forControlEvents:UIControlEventTouchUpInside];
    _button.titleLabel.font = [UIFont systemFontOfSize: fontNormal];
    _button.titleLabel.textAlignment = NSTextAlignmentRight;
     [self.view addSubview:_button];
 
       [_signButton setFrameOriginY:CGRectGetMaxY(_button.frame) + 5];
    
    _tableView.backgroundColor=[UIColor clearColor];
    [self checkAutoSignin];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)showSignup
{
    [self showSignup:[NSNumber numberWithBool:YES]];
}

- (void)showSignup:(NSNumber *)animate
{
    isSignUp = TRUE;
    __weak typeof(self) weakself = self;
    _signupViewController = [[SignupViewController alloc] init];
    _signupViewController.view.frame = self.view.bounds;
    _signupViewController.goBackBlock = ^() {
        [weakself closeSignup];
    };
    [self.view addSubview:_signupViewController.view];
    
    if ([animate boolValue]) {
        CGRect frame = self.view.bounds;
        frame.origin.y = CGRectGetHeight(frame);
        _signupViewController.view.frame = frame;
        
        frame.origin.y = 0;
        [UIView animateWithDuration:0.35
                         animations:^{
                             _signupViewController.view.frame = frame;
                         }];
    }
}

// 关闭登录
- (void)closeSignup
{
    isSignUp = FALSE;
    CGRect frame = _signupViewController.view.bounds;
    frame.origin.y = CGRectGetHeight(frame);
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         _signupViewController.view.frame = frame;
                     } completion:^(BOOL finished) {
                         [_signupViewController.view removeFromSuperview];
                         _signupViewController = nil;
                     }];
}



// 监听文字更改
- (void)textChanged:(NSNotification *)notification
{
    if (isSignUp) {
        return;
    }
    UITextField *textField = notification.object;
    if (textField.tag < 1000) {
        return;
    }
    NSInteger tag = textField.tag - 1000;
    @try {
        KeyPlaceholderValueModel *model = [_dataArray objectAtIndex:tag];
        model.value = textField.text;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if (textField.tag >= 1000) {
        NSInteger tag = textField.tag - 1000;
        
        if (tag == 1) {
            [self doSignin];
        } else {
            SigninPasswordTableViewCell *cell = (SigninPasswordTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag + 1 inSection:0]];
            [cell.textField becomeFirstResponder];
        }
    } else {
            if (textField.tag >= 2) {
                [textField resignFirstResponder];
                return YES;
            }
    }
    return YES;
}

#pragma mark UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyPlaceholderValueModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakself = self;
    SigninUserTableViewCell *cell;
    switch (indexPath.row) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SigninUserTableViewCell" forIndexPath:indexPath];
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        }
            
        case 1: {
            SigninPasswordTableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:@"SigninPasswordTableViewCell" forIndexPath:indexPath];
            theCell.textField.keyboardType = UIKeyboardTypeDefault;
            theCell.passwordBlock = ^() {
                [weakself showResetPassword];
            };
            theCell.textField.secureTextEntry = YES;
            cell = theCell;
            
            break;
        }
            
        default:
            break;
    }
     cell.backgroundColor= [UIColor clearColor];
    cell.iconImageView.image = [UIImage imageNamed:model.key];
    cell.textField.placeholder = model.placeholder;
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row + 1000;
    cell.textField.font = [UIFont systemFontOfSize:fontNormal];
    UIColor *color = [UIColor whiteColor];
    cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:model.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    if (model.value && model.value.length > 0) {
        cell.textField.text = model.value;
    }
    
    if (indexPath.row == 1) {
        cell.textField.returnKeyType = UIReturnKeyDone;
    } else {
        cell.textField.returnKeyType = UIReturnKeyNext;
    }
    
    return cell;
}


// 收回键盘
- (void)dismissKeyboard
{
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        SigninUserTableViewCell *cell = (SigninUserTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.textField.isFirstResponder) {
            [cell.textField resignFirstResponder];
        }
    }
}

// 登录


- (void)doSignin
{
    

    [self dismissKeyboard];
    
    NSString *tips;
    NSString *user = ((KeyPlaceholderValueModel *)[_dataArray objectAtIndex:0]).value;
    NSString *password = ((KeyPlaceholderValueModel *)[_dataArray objectAtIndex:1]).value;
    if (!user || user.length == 0) {
        tips = NSLocalizedString(@"localized185", nil);
    } else if (!password || password.length == 0) {
        tips = NSLocalizedString(@"localized186", nil);
    }
    if (tips) {
        [Constants showTipsMessage:tips];
        return;
    }
    
    [self signinMethod:user password:password];
}

// 显示重置密码
- (void)showResetPassword
{
    [super showForgetPassword];
}

// 关闭重置密码
- (void)closeResetPassword
{
    CGRect frame = _resetPasswordViewController.view.bounds;
    frame.origin.y = CGRectGetHeight(frame);
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         _resetPasswordViewController.view.frame = frame;
                     } completion:^(BOOL finished) {
                         [_resetPasswordViewController.view removeFromSuperview];
                         _resetPasswordViewController = nil;
                     }];
}

@end
