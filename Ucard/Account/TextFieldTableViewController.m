//
//  TextFieldTableViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "TextFieldTableViewController.h"
#import "TextFieldTableViewCell.h"

@interface TextFieldTableViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation TextFieldTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    [tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:@"TextFieldTableViewCell"];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
    cell.textField.delegate = self;
    cell.textField.returnKeyType = UIReturnKeyDone;
    cell.textField.placeholder = _placeholder;
    cell.textField.text = _value;
    _textField = cell.textField;
    
    return cell;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self goBack];
    } else {
        [_textField resignFirstResponder];
    }
    return YES;
}

// 返回
- (void)goBack
{
    if (self.submitBlock) {
        self.submitBlock(_textField.text ? _textField.text : @"");
    }
    
    [super goBack];
}

@end
