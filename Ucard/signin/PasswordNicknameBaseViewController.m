//
//  PasswordNicknameBaseViewController.m
//  Ucard
//
//  Created by Conner Wu on 15-4-13.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PasswordNicknameBaseViewController.h"
#import "TextFieldTableViewCell.h"

@interface PasswordNicknameBaseViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSString *_placeholder;
}
@end

@implementation PasswordNicknameBaseViewController

- (id)init:(NSString *)placeholder
{
    if (self = [super init]) {
        _placeholder = placeholder;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgGrayColor;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:_titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 15, 50, 50);
    [backButton setImage:[UIImage imageNamed:@"public-back-gray"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 20, kScreenWidth, 44) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    tableView.scrollEnabled = NO;
    [tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:@"TextFieldTableViewCell"];
    [self.view addSubview:tableView];
    
    _submitButton = [Constants createGreenButton:CGRectMake(10, CGRectGetMaxY(tableView.frame) + 20, kScreenWidth - 10 * 2, 44) title:NSLocalizedString(@"localized012", nil) sel:@selector(submit) target:self];
    [self.view addSubview:_submitButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
    cell.textField.placeholder = _placeholder;
    cell.textField.delegate = self;
    _textField = cell.textField;
    _textField.keyboardType = UIKeyboardTypeEmailAddress;
    _textField.returnKeyType = UIReturnKeyDone;
    
    return cell;
}


#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self submit];
    } else {
        [_textField resignFirstResponder];
    }
    return YES;
}

// 返回
- (void)goBack
{
    if (self.goBackBlock) {
        self.goBackBlock();
    }
}

- (void)submit
{
    
}

@end
