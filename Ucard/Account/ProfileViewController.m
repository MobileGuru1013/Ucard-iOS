//
//  ProfileViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ProfileViewController.h"
#import "KeyValueTableViewCell.h"
#import "ProfileHeaderTableViewCell.h"
#import "KeyValueModel.h"
#import "TextFieldTableViewController.h"
#import "ActionSheetStringPicker.h"
#import "PostcardCountryViewController.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    NSArray *_dataArray;
    UITableView *_tableView;
    UserInfoModel *_model;
}
@end
int cellHeight = 60;
@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRightButton];
    int fontSmall;
    if(kR35){
        cellHeight = 35;
        fontSmall = 13;
    }
    else if(kR40){
        cellHeight = 44;
        fontSmall = 15;
    }
    else if(kR47){
        cellHeight = 50;
        fontSmall = 16;
    }
    else if(kR55){
        cellHeight = 60;
        fontSmall = 17;
    }
    _dataArray = @[];
    CGRect frame = self.view.bounds;
    frame.origin.y = 5;
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0];
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[KeyValueTableViewCell class] forCellReuseIdentifier:@"KeyValueTableViewCell"];
    [_tableView registerClass:[ProfileHeaderTableViewCell class] forCellReuseIdentifier:@"ProfileHeaderTableViewCell"];
    [self.view addSubview:_tableView];
    
    NSDictionary *dic = [[Singleton shareInstance].user toDictionary];
    _model = [[UserInfoModel alloc] initWithDictionary:dic error:nil];
    int heightButton = cellHeight;
    UIButton *saveBtt = [UIButton buttonWithType:
                         UIButtonTypeRoundedRect];
    [saveBtt setFrame:CGRectMake(30, heightButton * 8 + 5 + 20, kScreenWidth-60, heightButton)];
    [saveBtt setTitle:NSLocalizedString(@"localized067", nil) forState:
     UIControlStateNormal];
    [saveBtt addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    saveBtt.titleLabel.font = [UIFont systemFontOfSize:fontSmall];
    saveBtt.backgroundColor=kGColor;
    [saveBtt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtt.layer.cornerRadius =  4;
    saveBtt.layer.borderColor = kGColor.CGColor;
    saveBtt.layer.borderWidth = 1;
    [self.view addSubview:saveBtt];
    [self reloadData:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.row == 0) {
        height = cellHeight + 10;
    } else {
        height = cellHeight;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell;
    
    if (indexPath.row == 0) {
        ProfileHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderTableViewCell" forIndexPath:indexPath];
        [Constants setHeaderImageView:cell.headerImageView path:[Singleton shareInstance].user.photo];
        cell.userName.text = _model.nickname;
        theCell = cell;
    } else {
        KeyValueModel *model = [_dataArray objectAtIndex:indexPath.row - 1];
        
        KeyValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KeyValueTableViewCell" forIndexPath:indexPath];
        cell.keyLabel.text = model.key;
        cell.valueLabel.text = model.value;
        
        theCell = cell;
    }
    
    
    return theCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self showAlbum];
    } else {
        KeyValueModel *model = [_dataArray objectAtIndex:indexPath.row - 1];
        
        SEL methodName = NSSelectorFromString(model.sel);
        if ([self respondsToSelector:methodName]) {
#pragma clang diagnositc push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:methodName withObject:indexPath];
#pragma clang diagnostic pop
        }
    }
}

- (void)reloadData:(BOOL)countryChanged
{
    NSString *countryString = @"";
    if (countryChanged) {
        countryString = [Constants getLocalizedCountry:_model.country];
    } else {
        KeyValueModel *model = [_dataArray objectAtIndex:5];
        countryString = model.value;
    }
    
    NSArray *array = @[@{@"key": NSLocalizedString(@"localized002", nil), @"value": [Constants handleString:_model.nickname], @"sel": @"showEdit:"},
                       @{@"key": NSLocalizedString(@"localized068", nil), @"value": [Constants handleString:_model.first_name], @"sel": @"showEdit:"},
                       @{@"key": NSLocalizedString(@"localized069", nil), @"value": [Constants handleString:_model.middle_name], @"sel": @"showEdit:"},
                       @{@"key": NSLocalizedString(@"localized070", nil), @"value": [Constants handleString:_model.last_name], @"sel": @"showEdit:"},
                       @{@"key": NSLocalizedString(@"localized071", nil), @"value": [Constants getSexDes:_model.sex], @"sel": @"showEditSex"},
                       @{@"key": NSLocalizedString(@"localized072", nil), @"value": [Constants handleString:countryString], @"sel": @"showEditCountry"}];
    _dataArray = [KeyValueModel arrayOfModelsFromDictionaries:array];
    [_tableView reloadData];
}
#pragma mark 图片
- (void)showAlbum
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"localized073", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"localized074", nil), NSLocalizedString(@"localized075", nil), nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        switch (buttonIndex) {
            case 0: {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
                break;
            }
                
            case 1: {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                break;
            }
                
            default:
                break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    [self photoSelected:image];
}

- (void)photoSelected:(UIImage *)image
{
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            NSString *path = [result objectForKey:@"data"];
            [[SDImageCache sharedImageCache] removeImageForKey:[Constants getFileURLString:path]
                                                withCompletion:^{
                                                    _model.photo = path;
                                                    [Singleton shareInstance].user.photo = path;
                                                    [weakself reloadData:NO];
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNicknameHeader" object:nil];
                                                }];
        }
    }];
    [request submitHeader:image];
}

- (void)showEdit:(NSIndexPath *)indexPath
{
    KeyValueModel *model = [_dataArray objectAtIndex:indexPath.row - 1];
    
    __weak typeof(self) weakself = self;
    TextFieldTableViewController *viewController = [[TextFieldTableViewController alloc] init];
    viewController.title = model.key;
    viewController.placeholder = model.key;
    viewController.value = model.value;
    viewController.submitBlock = ^(NSString *text) {
        [weakself valueChanged:text indexPath:indexPath];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)valueChanged:(NSString *)value indexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
            _model.nickname = value;;
            break;
            
        case 2:
            _model.first_name = value;;
            break;
            
        case 3:
            _model.middle_name = value;;
            break;
            
        case 4:
            _model.last_name = value;;
            break;
            
        default:
            break;
    }
    [self reloadData:NO];
}

#pragma mark 性别

- (void)showEditSex
{
    __weak typeof(self) weakself = self;
    [ActionSheetStringPicker showPickerWithTitle:nil
                                            rows:@[NSLocalizedString(@"localized076", nil), NSLocalizedString(@"localized077", nil)]
                                initialSelection:_model.sex == 0 ? 1 : 0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           _model.sex = selectedIndex == 0 ? 1 : 0;
                                           [weakself reloadData:NO];
                                       } cancelBlock:^(ActionSheetStringPicker *picker) {
                                           
                                       } origin:self.view];
}

#pragma mark 国家

- (void)showEditCountry
{
    __weak typeof(self) weakself = self;
    PostcardCountryViewController *viewController = [[PostcardCountryViewController alloc] init];
    viewController.countryBlock = ^(CountryModel *country) {
        _model.country = country.key;
        [weakself reloadData:YES];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)submit
{
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized078", nil)];
            [Singleton shareInstance].user = _model;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNicknameHeader" object:nil];
        }
    }];
    [request submitUserInfo:_model];
}

@end
