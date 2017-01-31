//
//  AccountAddressViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/2.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountAddressViewController.h"
#import "SVProgressHUD.h"
#import "AddressTextFieldCell.h"
#import "KeyValueModel.h"
#import "TPKeyboardAvoidingTableView.h"
#import "PostcardCountryViewController.h"

@interface AccountAddressViewController () <UITableViewDataSource, UITableViewDelegate>
{
    TPKeyboardAvoidingTableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation AccountAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightButtonWithTitle:NSLocalizedString(@"localized067", nil) target:self selector:@selector(submit)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    NSArray *array = @[@{@"key": NSLocalizedString(@"localized122", nil), @"value": [Constants handleString:[Singleton shareInstance].user.house_number]},
                       @{@"key": NSLocalizedString(@"localized123", nil), @"value": [Constants handleString:[Singleton shareInstance].user.street]},
                       @{@"key": NSLocalizedString(@"localized124", nil), @"value": [Constants handleString:[Singleton shareInstance].user.city]},
                       @{@"key": NSLocalizedString(@"localized125", nil), @"value": [Constants handleString:[Singleton shareInstance].user.county]},
                       @{@"key": NSLocalizedString(@"localized126", nil), @"value": [Constants handleString:[Singleton shareInstance].user.postcode]}];
    _dataArray = [KeyValueModel arrayOfModelsFromDictionaries:array];
    
    _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[AddressTextFieldCell class] forCellReuseIdentifier:@"AddressTextFieldCell"];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

// 监听文字更改
- (void)textChanged:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if (textField.tag >= 100) {
        NSString *text = textField.text;
        NSInteger tag = textField.tag - 100;
        KeyValueModel *model = [_dataArray objectAtIndex:tag];
        model.value = text;
    }
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
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    AddressTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTextFieldCell" forIndexPath:indexPath];
    cell.textField.placeholder = model.key;
    cell.textField.text = model.value;
    cell.textField.tag = indexPath.row + 100;
    
    return cell;
}

- (void)submit
{
    NSString *tips;
    for (NSUInteger i = 0; i < _dataArray.count - 1; i++) {
        KeyValueModel *model = [_dataArray objectAtIndex:i];
        if (!model.value || model.value.length == 0) {
            tips = [NSString stringWithFormat:@"%@%@", i == _dataArray.count - 1 ? NSLocalizedString(@"localized192", nil) : NSLocalizedString(@"localized191", nil), [model.key lowercaseString]];
            break;
        }
    }
    if (tips) {
        [Constants showTipsMessage:tips];
        return;
    }
    
    NSString *building;
    NSString *street;
    NSString *city;
    NSString *province;
    NSString *zip;
    for (NSUInteger i = 0; i < _dataArray.count; i++) {
        KeyValueModel *model = [_dataArray objectAtIndex:i];
        switch (i) {
            case 0:
                building = model.value;
                break;
                
            case 1:
                street = model.value;
                break;
                
            case 2:
                city = model.value;
                break;
                
            case 3:
                province = model.value;
                break;
                
            case 4:
                zip = model.value;
                break;
                
            default:
                break;
        }
    }
    
    NSDictionary *dic = [[Singleton shareInstance].user toDictionary];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dic error:nil];
    model.house_number = building;
    model.street = street;
    model.city = city;
    model.county = province;
    model.postcode = zip;
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized088", nil)];
            [Singleton shareInstance].user = model;
            
            if (weakself.submitBlock) {
                weakself.submitBlock(nil);
            }
            
            [weakself goBack];
        }
    }];
    [request submitUserInfo:model];
}

- (void)goBack
{
    [super goBack];
}

@end
