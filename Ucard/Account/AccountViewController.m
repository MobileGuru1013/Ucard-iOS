//
//  AccountViewController.m
//  Ucard
//
//  Created by Conner Wu on 15-4-7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountViewController.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "SearchCardViewController.h"
#import "AccountHeaderCell.h"
#import "AccountButtonHeaderView.h"
#import "AccountDraftCell.h"
#import "AccountSendCell.h"
#import "AccountReceiveCell.h"
#import "AccountSendModel.h"
#import "SendDetailViewController.h"
#import "ReceiveDetailViewController.h"
#import "ConfigModel.h"
#import "AppDelegate.h"
#import "LocationModel.h"

typedef NS_ENUM(NSUInteger, CardListType) {
    CardListTypeDraft = 0,
    CardListTypeSend = 1,
    CardListTypeReceive = 2,
    CardListTypeLocation = 3
};

@interface AccountViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_draftArray;
    NSArray *_sendArray;
    NSArray *_receiveArray;
    NSArray *_currentArray;
    UITableView *_tableView;
    AccountButtonHeaderView *_sectionHeaderView;
    CardListType _listType;
}
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDraft) name:@"ReloadDraftNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSend) name:@"ReloadSendNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadReceive) name:@"ReloadReceiveNotification" object:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    CGRect frame = _tableView.frame;
    frame.size.height -= 60;
    _tableView.frame = frame;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[AccountHeaderCell class] forCellReuseIdentifier:@"AccountHeaderCell"];
    [_tableView registerClass:[AccountDraftCell class] forCellReuseIdentifier:@"AccountDraftCell"];
    [_tableView registerClass:[AccountSendCell class] forCellReuseIdentifier:@"AccountSendCell"];
    [_tableView registerClass:[AccountReceiveCell class] forCellReuseIdentifier:@"AccountReceiveCell"];
    [_tableView registerClass:[AccountButtonHeaderView class] forHeaderFooterViewReuseIdentifier:@"AccountButtonHeaderView"];
    [self.view addSubview:_tableView];
    
    
      
    [self performSelector:@selector(getCardCount) withObject:nil afterDelay:0.1];
    
    [self getDraft:NO];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadDraftNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadSendNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadReceiveNotification" object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
            
        case 1:
            count = _currentArray ? _currentArray.count : 0;
            break;
            
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = CGFLOAT_MIN;
    switch (section) {
        case 0:
            height = CGFLOAT_MIN;
            break;
            
        case 1:
            height = [AccountButtonHeaderView height];
            break;
            
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = CGFLOAT_MIN;
    switch (indexPath.section) {
        case 0:
            height = [AccountHeaderCell height];
            break;
            
        case 1:
            height = [AccountCardBaseCell height];
            
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if (!_sectionHeaderView) {
            __weak typeof(self) weakself = self;
            AccountButtonHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"AccountButtonHeaderView"];
            view.draftBlock = ^() {
                [weakself getDraft:NO];
            };
            view.sendBlock = ^() {
                [weakself getSend:NO];
            };
            view.receiveBlock = ^() {
                [weakself getReceive:NO];
            };
            
            _sectionHeaderView = view;
        }
        return _sectionHeaderView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell;
    __weak typeof(self) weakself = self;
    switch (indexPath.section) {
        case 0: {
            AccountHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountHeaderCell" forIndexPath:indexPath];
            cell.editProfileBlock = ^(UIButton *button) {
                [weakself editProfile:button];
            };
            cell.showSettingsBlock = ^(UIButton *button) {
                [weakself showSettings:button];
            };
            cell.showSearchCardBlock = ^() {
                [weakself showSearchCard];
            };
            theCell = cell;
            
            break;
        }
            
        case 1:
            if (_listType == CardListTypeDraft) {
                DraftCardModel *model = [_currentArray objectAtIndex:indexPath.row];
                
                AccountDraftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountDraftCell" forIndexPath:indexPath];
                
                
                cell.photoImageView.image = model.photoImage;
                cell.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.photoImageView.clipsToBounds = YES;

                theCell = cell;
            } else if (_listType == CardListTypeSend) {
                DraftCardModel *model = [_currentArray objectAtIndex:indexPath.row];
                
                AccountSendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountSendCell" forIndexPath:indexPath];
                
                cell.photoImageView.image = model.photoImage;
                cell.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.photoImageView.clipsToBounds = YES;

                theCell = cell;
            } else if (_listType == CardListTypeReceive) {
                DraftCardModel *model = [_currentArray objectAtIndex:indexPath.row];
                 AccountReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountReceiveCell" forIndexPath:indexPath];
                
                cell.photoImageView.image = model.photoImage;
                cell.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.photoImageView.clipsToBounds = YES;

                theCell = cell;
            }
            
        default:
            break;
    }
    
    return theCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (_listType == CardListTypeDraft) {
            [self editDraft];
        } else if (_listType == CardListTypeSend) {
            AccountSendModel *model = [_currentArray objectAtIndex:indexPath.row];
            
            SendDetailViewController *viewController = [[SendDetailViewController alloc] init];
            viewController.cardId = model.postcard_id;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        } else if (_listType == CardListTypeReceive) {
            AccountSendModel *model = [_currentArray objectAtIndex:indexPath.row];
            
            ReceiveDetailViewController *viewController = [[ReceiveDetailViewController alloc] init];
            viewController.cardId = model.postcard_id;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_listType == CardListTypeDraft) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"localized201", nil);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [DraftCardModel deleteData];
        
        [[AppDelegate shareDelegate] reloadCardViewController];
        
        _draftArray = @[];
        [tableView reloadData];
    }
}

- (void)getCardCount
{
    [self getDraft:YES];
    [self getSend:YES];
    [self getReceive:YES];
}

- (void)editProfile:(UIButton *)button
{
    ProfileViewController *viewController = [[ProfileViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.title = [button titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showSettings:(UIButton *)button
{
    SettingsViewController *viewController = [[SettingsViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.title = [button titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:viewController animated:YES];
}

// 编辑草稿
- (void)editDraft
{
    [self.navigationController.tabBarController setSelectedIndex:1];
}

// 查收
- (void)showSearchCard
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[SearchCardViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kIsReceivedTabNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kIsReceivedAccountNotification object:nil];
}

// 草稿
- (void)getDraft:(BOOL)forCount
{
    DraftCardModel *model = [DraftCardModel select];
    if (model.photoImage) {
        _draftArray = @[model];
    } else {
        _draftArray = @[];
    }
    if (!forCount) {
        _listType = CardListTypeDraft;
    }
    [self reloadCardSection:_draftArray forCount:forCount];
}

- (void)reloadDraft
{
    DraftCardModel *model = [DraftCardModel select];
    if (model.photoImage) {
        _draftArray = @[model];
    } else {
        _draftArray = @[];
    }
    
    [self showDraftCount];
    if (_sectionHeaderView.draftButton.isSelected) {
        _listType = CardListTypeDraft;
        [self reloadCardSection:_draftArray forCount:NO];
    }
}

// 寄信
- (void)getSend:(BOOL)forCount
{
    if (!forCount) {
        _listType = CardListTypeSend;
    }
    if (_sendArray && _sendArray.count > 0) {
        [self reloadCardSection:_sendArray forCount:forCount];
    } else {
        __weak typeof(self) weakself = self;
        NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
        [request completion:^(id result, BOOL succ) {
            _sendArray = @[];
            if (succ) {
                NSArray *data = [result objectForKey:@"data"];
                data = [data isKindOfClass:[NSArray class]] ? data : @[];
                _sendArray = [AccountSendModel arrayOfModelsFromDictionaries:data];
            }
            [weakself reloadCardSection:_sendArray forCount:forCount];
        }];
        [request getSendList:!forCount];
    }
}

- (void)reloadSend
{
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        _sendArray = @[];
        if (succ) {
            _sendArray = [AccountSendModel arrayOfModelsFromDictionaries:[result objectForKey:@"data"]];
        }
        [weakself showSendCount];
        if (_sectionHeaderView.sendButton.isSelected) {
            _listType = CardListTypeSend;
            [weakself reloadCardSection:_sendArray forCount:NO];
        }
    }];
    [request getSendList:NO];
}

// 收信
- (void)getReceive:(BOOL)forCount
{
    if (!forCount) {
        _listType = CardListTypeReceive;
    }
    if (_receiveArray && _receiveArray.count > 0) {
        [self reloadCardSection:_receiveArray forCount:forCount];
    } else {
        __weak typeof(self) weakself = self;
        NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
        [request completion:^(id result, BOOL succ) {
            _receiveArray = @[];
            if (succ) {
                NSArray *data = [result objectForKey:@"data"];
                data = [data isKindOfClass:[NSArray class]] ? data : @[];
                _receiveArray = [AccountSendModel arrayOfModelsFromDictionaries:data];
            }
            [weakself reloadCardSection:_receiveArray forCount:forCount];
        }];
        [request getReceiveList:!forCount];
    }
}
- (void)reloadReceive
{
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        _receiveArray = @[];
        if (succ) {
            _receiveArray = [AccountSendModel arrayOfModelsFromDictionaries:[result objectForKey:@"data"]];
        }
        [weakself showReceiveCount];
        if (_sectionHeaderView.receiveButton.isSelected) {
            _listType = CardListTypeReceive;
            [weakself reloadCardSection:_receiveArray forCount:NO];
        }
    }];
    [request getReceiveList:NO];
}






// 按钮显示数量
- (void)reloadCardSection:(NSArray *)array forCount:(BOOL)forCount
{
    if (!forCount) {
        _currentArray = array;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (array == _draftArray) {
        [self showDraftCount];
    } else if (array == _sendArray) {
        [self showSendCount];
    } else if (array == _receiveArray) {
        [self showReceiveCount];
    }
}

- (void)showDraftCount
{
    _sectionHeaderView.draftButton.countLabel.text = _draftArray ? [NSString stringWithFormat:@"%lu", (unsigned long)_draftArray.count] : @"0";
}

- (void)showSendCount
{
    _sectionHeaderView.sendButton.countLabel.text = _sendArray ? [NSString stringWithFormat:@"%lu", (unsigned long)_sendArray.count] : @"0";
}

- (void)showReceiveCount
{
    _sectionHeaderView.receiveButton.countLabel.text = _receiveArray ? [NSString stringWithFormat:@"%lu", (unsigned long)_receiveArray.count] : @"0";
}

@end
