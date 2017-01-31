//
//  SignupViewController.m
//  Ucard
//
//  Created by Conner Wu on 15-4-8.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SignupViewController.h"
#import "SigninViewController.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "UIView+Frame.h"
#import "UnderlineButton.h"
#import "LicenceViewController.h"

@interface SignupViewController () <UITextFieldDelegate>
{
    SigninViewController *_signinViewController;
    UIButton *_checkButton;
}
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedSignup:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _titleLabel.text = NSLocalizedString(@"localized004", nil);
    
    NSArray *array = @[@{@"key":@"email", @"placeholder" :  NSLocalizedString( @"localized001",nil)},
                       @{ @"key": @"name",@"placeholder": NSLocalizedString(@"localized002", nil)},
                       @{ @"key": @"password" ,@"placeholder": NSLocalizedString(@"localized003", nil)}];
    _dataArray = [KeyPlaceholderValueModel arrayOfModelsFromDictionaries:array];
    
    [super createOtherView:NSLocalizedString(@"localized004", nil) sel:@selector(doSignup) signup:YES];
    
    // 协议
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton.frame = CGRectMake(_signButton.frame.origin.x, CGRectGetMaxY(_tableView.frame) + 15, 20, 20);
    [_checkButton setImage:[UIImage imageNamed:@"pay-agree-unselected"] forState:UIControlStateNormal];
    [_checkButton setImage:[UIImage imageNamed:@"pay-agree-selected"] forState:UIControlStateSelected];
    [_checkButton addTarget:self action:@selector(agreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkButton];
    
    
    NSString *text = NSLocalizedString(@"localized027", nil);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_tableView.frame.origin.x + 30, CGRectGetMinY(_checkButton.frame), 0, CGRectGetHeight(_checkButton.frame))];
    label.text = text;
    label.font = [UIFont systemFontOfSize:[Constants isCNLanguage] ? 15 : fontSmall];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    CGRect rect =[label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil];
    [label setFrameWidth:rect.size.width];
    
    NSString *string = NSLocalizedString(@"localized028", nil);
    CGRect stringRect =[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 5, CGRectGetMinY(label.frame), CGRectGetWidth(stringRect), CGRectGetHeight(label.frame))];
    btn.titleLabel.font = label.font;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:string forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showLicence) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
   
    [_signButton setFrameOriginY:CGRectGetMaxY(_checkButton.frame) + 15];
    
    _tipsLabel.text = NSLocalizedString(@"localized006", nil);
    [_tipsButton setTitle:NSLocalizedString(@"localized007", nil) forState:UIControlStateNormal];
    [_tipsButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    int lblWidth;
    int bttWidth = 50;
    if (kR55) {
        bttWidth = 50;
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
     _tableView.backgroundColor= [UIColor clearColor];
    
//    [self checkAutoSignin];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回
- (void)goBack
{
    if (self.goBackBlock) {
        self.goBackBlock();
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)agreeButtonClicked:(UIButton *)button
{
    button.selected = !button.isSelected;
}

- (void)showLicence
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[LicenceViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
}


// 监听文字更改
- (void)textChangedSignup:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if (textField.tag < 1000) {
        return;
    }
    NSInteger tag = textField.tag - 1000;
    KeyPlaceholderValueModel *model = [_dataArray objectAtIndex:tag];
    model.value = textField.text;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if (textField.tag >= 1000) {
        NSInteger tag = textField.tag - 1000;
        
        if (tag == 2) {
            [self dismissKeyboard];
        } else {
            SignupTableViewCell *cell = (SignupTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag + 1 inSection:0]];
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
    
    SignupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignupTableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor= [UIColor clearColor];
    cell.iconImageView.image = [UIImage imageNamed:model.key];
    cell.keyLabel.text = model.key;
    cell.textField.placeholder = model.placeholder;
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row + 1000;
    
    
    cell.textField.font = [UIFont systemFontOfSize:fontNormal];
    UIColor *color = [UIColor whiteColor];
    cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:model.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    if (indexPath.row == 2) {
        cell.textField.secureTextEntry = YES;
        cell.textField.returnKeyType = UIReturnKeyDone;
     
    } else {
        cell.textField.secureTextEntry = NO;
        cell.textField.returnKeyType = UIReturnKeyNext;
    }
    switch (indexPath.row) {
        case 0:
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
            
        default:
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
    
    return cell;
}

// 关闭键盘
- (void)dismissKeyboard
{
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        SignupTableViewCell *cell = (SignupTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.textField.isFirstResponder) {
            [cell.textField resignFirstResponder];
        }
    }
}

// 注册
- (void)doSignup
{
    [self dismissKeyboard];
    
    NSString *email = ((KeyPlaceholderValueModel *)[_dataArray objectAtIndex:0]).value;
    NSString *nickname = ((KeyPlaceholderValueModel *)[_dataArray objectAtIndex:1]).value;
    NSString *password = ((KeyPlaceholderValueModel *)[_dataArray objectAtIndex:2]).value;
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL emailPass = [emailTest evaluateWithObject:email];
    
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    BOOL passwordPass = [passWordPredicate evaluateWithObject:password];
    
    NSString *tips;
    if (!email || email.length == 0) {
        tips = NSLocalizedString(@"localized195", nil);
    } else if (!emailPass) {
        tips = NSLocalizedString(@"localized198", nil);
    } else if (!nickname || nickname.length == 0) {
        tips = NSLocalizedString(@"localized196", nil);
    } else if (!password || password.length == 0) {
        tips = NSLocalizedString(@"localized197", nil);
    } else if (!passwordPass) {
        tips = NSLocalizedString(@"localized199", nil);
    } else if (!_checkButton.isSelected) {
        tips = NSLocalizedString(@"localized031", nil);
    }
    
    if (tips) {
        [Constants showTipsMessage:tips];
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    [_signButton startLoading];
    
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request completion:^(id result, BOOL succ) {
        self.view.userInteractionEnabled = YES;
        [_signButton stopLoading];
        if (succ) {
            [UserModel signinSucceed:[result objectForKey:@"data"] user:email password:password type:@"email"];
            [[AppDelegate shareDelegate] setRootHome];
        } else {
            [_signButton stopLoading];
        }
    }];
    [request signup:email nickname:nickname password:password];
}

@end
