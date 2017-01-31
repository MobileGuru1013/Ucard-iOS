//
//  AccountInfoViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/2.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "KeyValueModel.h"
#import "AccountInfoHeaderView.h"
#import "AccountEmailViewController.h"
#import "AccountPasswordViewController.h"
#import "AccountAddressViewController.h"
#import "ActionSheetDatePicker.h"
#import "AccountInfoTableCell.h"
#import "SVProgressHUD.h"

@interface AccountInfoViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataArray;
    UITableView *_tableView;
}
@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRightButton];
    _dataArray = @[];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 60)];
    scrollView.backgroundColor = [UIColor clearColor];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:contentView];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = FALSE;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[AccountInfoTableCell class] forCellReuseIdentifier:@"AccountInfoTableCell"];
    [_tableView registerClass:[AccountInfoHeaderView class] forHeaderFooterViewReuseIdentifier:@"AccountInfoHeaderView"];
    CGRect frame = _tableView.frame;
    frame.origin.x = 10;
    frame.origin.y = 2;
    frame.size.width = frame.size.width - 20;
    frame.size.height = (44 + 60) * 4;
    _tableView.frame = frame;
    [contentView addSubview:_tableView];
    UIButton *doneBtt = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtt addTarget:self
                  action:@selector(submitData)forControlEvents:UIControlEventTouchUpInside];
    [doneBtt setTitle:@"localized117" forState:UIControlStateNormal];
    doneBtt.frame =CGRectMake(40,kScreenHeight - 60 - 20 - 40,kScreenWidth-40 * 2 , 40);
    doneBtt.backgroundColor=kGColor;
    doneBtt.layer.cornerRadius =  4;
    doneBtt.layer.borderColor = kGColor.CGColor;
    doneBtt.layer.borderWidth = 1;
    doneBtt.titleLabel.font = [UIFont systemFontOfSize:15];
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0];
    [contentView addSubview:doneBtt];
    int topYBtt = CGRectGetMinY(doneBtt.frame);
    int botYTbv = CGRectGetMaxY(_tableView.frame);
    if(topYBtt < botYTbv + 20) {
        topYBtt = botYTbv + 20;
        CGRect frameBtt = doneBtt.frame;
        frameBtt.origin.y = topYBtt;
        doneBtt.frame = frameBtt;
        frame = contentView.frame;
        frame.size.height = CGRectGetMaxY(doneBtt.frame) + 20;
        contentView.frame = frame;
    }
    scrollView.contentSize = contentView.frame.size;
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    KeyValueModel *model = [_dataArray objectAtIndex:section];
    
    AccountInfoHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"AccountInfoHeaderView"];
    view.contentView.backgroundColor = [UIColor whiteColor];
    view.label.text = model.key;
    view.label.frame = CGRectMake(0, 10, _tableView.frame.size.width, 30);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueModel *model = [_dataArray objectAtIndex:indexPath.section];
    
    AccountInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountInfoTableCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    CGRect frame = cell.paddingView.frame;
    frame.size.width = tableView.frame.size.width - 30 * 2;
    cell.paddingView.frame = frame;
    cell.textLbl.text = model.value;
    cell.textLbl.textAlignment = NSTextAlignmentCenter;
    if (indexPath.section == 0) {
        cell.paddingView.backgroundColor = [UIColor clearColor];
        cell.paddingView.layer.borderWidth = 0;
    } else {
        cell.paddingView.backgroundColor = [UIColor whiteColor];
        cell.paddingView.layer.borderWidth = 1;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KeyValueModel *model = [_dataArray objectAtIndex:indexPath.section];
    
    SEL methodName = NSSelectorFromString(model.sel);
    if ([self respondsToSelector:methodName]) {
#pragma clang diagnositc push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:methodName withObject:indexPath];
#pragma clang diagnostic pop
    }
}

- (void)reloadData
{
    NSArray *array = @[@{@"key": NSLocalizedString(@"localized001", nil), @"value": [Constants handleString:[Singleton shareInstance].user.email], @"sel": @"showEditEmail:"},
                       @{@"key": NSLocalizedString(@"localized003", nil), @"value": NSLocalizedString(@"localized081", nil), @"sel": @"showEditPassword:"},
                       @{@"key": NSLocalizedString(@"localized079", nil), @"value": [Constants handleString:[Singleton shareInstance].user.date_of_birth], @"sel": @"showEditBirth:"},
                       @{@"key": NSLocalizedString(@"localized080", nil), @"value": [NSString stringWithFormat:@"%@ %@ %@ %@ %@", [Singleton shareInstance].user.house_number, [Singleton shareInstance].user.street, [Singleton shareInstance].user.city, [Singleton shareInstance].user.county, [Singleton shareInstance].user.postcode], @"sel": @"showEditAddress:"}];
    _dataArray = [KeyValueModel arrayOfModelsFromDictionaries:array];
    [_tableView reloadData];
}

- (void)showEditEmail:(NSIndexPath *)indexPath
{
    return;
    KeyValueModel *model = [_dataArray objectAtIndex:indexPath.section];
    
    __weak typeof(self) weakself = self;
    AccountEmailViewController *viewController = [[AccountEmailViewController alloc] init];
    viewController.title = model.key;
    viewController.placeholder = model.key;
    viewController.value = model.value;
    viewController.submitBlock = ^(NSString *text) {
        [weakself reloadData];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showEditPassword:(NSIndexPath *)indexPath
{
    KeyValueModel *model = [_dataArray objectAtIndex:indexPath.section];
    
    AccountPasswordViewController *viewController = [[AccountPasswordViewController alloc] init];
    viewController.title = model.key;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showEditBirth:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[Singleton shareInstance].user.date_of_birth];
    
    [ActionSheetDatePicker showPickerWithTitle:nil
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:date
                                        target:self
                                        action:@selector(dateSelected:)
                                        origin:self.view];
}

- (void)dateSelected:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *birth = [dateFormatter stringFromDate:date];
    
    NSDictionary *dic = [[Singleton shareInstance].user toDictionary];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dic error:nil];
    model.date_of_birth = birth;
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized082", nil)];
            [Singleton shareInstance].user = model;
            [weakself reloadData];
        }
    }];
    [request submitUserInfo:model];
}

- (void)showEditAddress:(NSIndexPath *)indexPath
{
    KeyValueModel *model = [_dataArray objectAtIndex:indexPath.section];
    
    __weak typeof(self) weakself = self;
    AccountAddressViewController *viewController = [[AccountAddressViewController alloc] init];
    viewController.title = model.key;
    viewController.value = model.value;
    viewController.submitBlock = ^(NSString *text) {
        [weakself reloadData];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) submitData {
    NSDictionary *dic = [[Singleton shareInstance].user toDictionary];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dic error:nil];
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized082", nil)];
            [Singleton shareInstance].user = model;
            [self goBack];
        }
    }];
    [request submitUserInfo:model];
}

@end
