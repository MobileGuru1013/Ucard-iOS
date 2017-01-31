//
//  AddressPopView.m
//  Ucard
//
//  Created by WuLeilei on 15/4/24.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AddressPopView.h"
#import "AddressTextFieldCell.h"
#import "AddressCountryCell.h"
#import "KeyValueModel.h"
#import "TPKeyboardAvoidingTableView.h"

@interface AddressPopView () <UITableViewDataSource, UITableViewDelegate>
{
    TPKeyboardAvoidingTableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation AddressPopView

- (id)initWithFrame:(CGRect)frame bgFrame:(CGRect)bgFrame title:(NSString *)title
{
    if (self = [super initWithFrame:frame bgFrame:bgFrame title:title]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        
        DraftCardModel *model = [Singleton shareInstance].cardModel;
        NSArray *array = @[@{@"key": NSLocalizedString(@"localized119", nil), @"value": [Constants handleString:model.firstName]},
                           @{@"key": NSLocalizedString(@"localized120", nil), @"value": [Constants handleString:model.middleName]},
                           @{@"key": NSLocalizedString(@"localized121", nil), @"value": [Constants handleString:model.lastName]},
                           @{@"key": NSLocalizedString(@"localized122", nil), @"value": [Constants handleString:model.building]},
                           @{@"key": NSLocalizedString(@"localized123", nil), @"value": [Constants handleString:model.street]},
                           @{@"key": NSLocalizedString(@"localized124", nil), @"value": [Constants handleString:model.city]},
                           @{@"key": NSLocalizedString(@"localized125", nil), @"value": [Constants handleString:model.province]},
                           @{@"key": NSLocalizedString(@"localized126", nil), @"value": [Constants handleString:model.zip]},
                           @{@"key": model.country ? model.country : NSLocalizedString(@"localized127", nil), @"value": [Constants handleString:model.country]}];
        _dataArray = [KeyValueModel arrayOfModelsFromDictionaries:array];
        
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame) - 105)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[AddressTextFieldCell class] forCellReuseIdentifier:@"AddressTextFieldCell"];
        [_tableView registerClass:[AddressCountryCell class] forCellReuseIdentifier:@"AddressCountryCell"];
        [_bgView addSubview:_tableView];
        
        [self performSelector:@selector(checkForm) withObject:nil afterDelay:0.1];
    }
    return self;
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
        
        [self checkForm];
    }
}

- (void)checkForm
{
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
    
    UITableViewCell *theCell;
    if (indexPath.row < _dataArray.count - 1) {
        AddressTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTextFieldCell" forIndexPath:indexPath];
        cell.textField.placeholder = model.key;
        cell.textField.text = model.value;
        cell.textField.tag = indexPath.row + 100;
        
        theCell = cell;
    } else {
        AddressCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCountryCell" forIndexPath:indexPath];
        cell.textLbl.text = model.key;
        
        theCell = cell;
    }
    return theCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArray.count - 1) {
        if (self.showCountryBlock) {
            self.showCountryBlock();
        }
    }
}

- (void)done
{
    NSString *tips;
    for (NSUInteger i = 0; i < _dataArray.count - 1; i++) {
        KeyValueModel *model = [_dataArray objectAtIndex:i];
        if (i != 1 && i != 7) {
            if (!model.value || model.value.length == 0) {
                tips = [NSString stringWithFormat:@"%@%@", i == _dataArray.count - 1 ? NSLocalizedString(@"localized192", nil) : NSLocalizedString(@"localized191", nil), [model.key lowercaseString]];
                break;
            }
        }
    }
    if (tips) {
        [Constants showTipsMessage:tips];
        return;
    }
    
    for (NSUInteger i = 0; i < _dataArray.count; i++) {
        KeyValueModel *model = [_dataArray objectAtIndex:i];
        switch (i) {
            case 0:
                [Singleton shareInstance].cardModel.firstName = model.value;
                break;
                
            case 1:
                [Singleton shareInstance].cardModel.middleName = model.value;
                break;
                
            case 2:
                [Singleton shareInstance].cardModel.lastName = model.value;
                break;
                
            case 3:
                [Singleton shareInstance].cardModel.building = model.value;
                break;
                
            case 4:
                [Singleton shareInstance].cardModel.street = model.value;
                break;
                
            case 5:
                [Singleton shareInstance].cardModel.city = model.value;
                break;
                
            case 6:
                [Singleton shareInstance].cardModel.province = model.value;
                break;
                
            case 7:
                [Singleton shareInstance].cardModel.zip = model.value;
                break;
                
            case 8:
                [Singleton shareInstance].cardModel.country = model.value;
                break;
                
            default:
                break;
        }
    }
    
    [[Singleton shareInstance].cardModel updateData];
    
    [super done];
}

- (void)setCountryModel:(CountryModel *)countryModel
{
    _countryModel = countryModel;
    
    [Singleton shareInstance].cardModel.countryId = countryModel.key;
    
    KeyValueModel *model = [_dataArray lastObject];
    model.key = _countryModel.en;
    model.value = model.key;
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
    [self checkForm];
}

@end