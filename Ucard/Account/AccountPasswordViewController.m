//
//  AccountPasswordViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/2.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountPasswordViewController.h"
#import "TextFieldTableViewCell.h"
#import "KeyValueModel.h"
#import "SVProgressHUD.h"
#import "UserModel.h"

@interface AccountPasswordViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_dataArray;
    UITableView *_tableView;
}
@end

@implementation AccountPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
    [self setRightButtonWithTitle:NSLocalizedString(@"localized067", nil) target:self selector:@selector(submit)];
    
    NSArray *array = @[@{@"key": NSLocalizedString(@"localized084", nil), @"value": @""},
                       @{@"key": NSLocalizedString(@"localized085", nil), @"value": @""}];
    _dataArray = [KeyValueModel arrayOfModelsFromDictionaries:array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:@"TextFieldTableViewCell"];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
}

// 监听文字更改
- (void)textChanged:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    NSInteger tag = textField.tag;
    KeyValueModel *model = [_dataArray objectAtIndex:tag];
    model.value = textField.text;
}

// 监听密码输入框焦点
- (void)startEditing:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    textField.secureTextEntry = NO;
}

- (void)endEditing:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    textField.secureTextEntry = YES;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
        TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.textField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
    cell.textField.placeholder = model.key;
    cell.textField.text = model.value;
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
            cell.textField.returnKeyType = UIReturnKeyNext;
            break;
            
        case 1:
            cell.textField.returnKeyType = UIReturnKeyDone;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)submit
{
    NSString *tips;
    for (NSUInteger i = 0; i < _dataArray.count; i++) {
        KeyValueModel *model = [_dataArray objectAtIndex:i];
        NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
        BOOL passwordPass = [passWordPredicate evaluateWithObject:model.value];
        if (!passwordPass) {
            tips = NSLocalizedString(@"localized086", nil);
        }
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
    
    KeyValueModel *model1 = [_dataArray objectAtIndex:0];
    NSString *oldpassword = model1.value;
    KeyValueModel *model2 = [_dataArray objectAtIndex:1];
    NSString *password = model2.value;
    
    NSArray *array = [UserModel getAccount];
    if (![[array objectAtIndex:1] isEqualToString:oldpassword]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"localized087", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized088", nil)];
            
            [UserModel updatePassword:password];
            
            [weakself goBack];
        }
    }];
    [request changePassword:password];
}

@end
