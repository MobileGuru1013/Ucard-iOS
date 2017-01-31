//
//  ReceiveDetailViewController.m
//  Ucard
//
//  Created by Conner Wu on 15/5/8.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ReceiveDetailViewController.h"
#import "ReceiveDetailHeaderView.h"
#import "ReceiveDetailUserCell.h"
#import "ReceiveDetailKeyValueCell.h"
#import "CommunityDetailViewController.h"
#import "ShareOperation.h"

@interface ReceiveDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    ReceiveDetailModel *_cardModel;
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation ReceiveDetailViewController

int cellHeight2 = 60;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRightButton];
    int fontSmall;
    if(kR35){
        cellHeight2 = 35;
        fontSmall = 13;
    }
    else if(kR40){
        cellHeight2 = 44;
        fontSmall = 15;
    }
    else if(kR47){
        cellHeight2 = 50;
        fontSmall = 16;
    }
    else if(kR55){
        cellHeight2 = 60;
        fontSmall = 17;
    }
    self.title = NSLocalizedString(@"localized098", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showData];
    [self hideRightButton];
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

- (void)getData
{
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            NSError *error;
            _cardModel = [[ReceiveDetailModel alloc] initWithDictionary:[result objectForKey:@"data"] error:&error];
            if (_cardModel) {
                _cardModel.postcard_id = _cardId;
                [weakself showData];
            } else {
                NSLog(@"%@", error);
            }
        }
    }];
    [request getReceiveCardDetail:_cardId];
}

- (void)showData
{
    if (!_cardModel) {
        return;
    }
    
    _dataArray = @[@{@"key": NSLocalizedString(@"localized105", nil), @"value": _cardModel.postcard_id},
                   @{@"key": NSLocalizedString(@"localized106", nil), @"value": _cardModel.receiver_country},
                   @{@"key": NSLocalizedString(@"localized107", nil), @"value": _cardModel.postcard_making_time}];
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ReceiveDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"ReceiveDetailHeaderView"];
        [_tableView registerClass:[ReceiveDetailUserCell class] forCellReuseIdentifier:@"ReceiveDetailUserCell"];
        [_tableView registerClass:[ReceiveDetailKeyValueCell class] forCellReuseIdentifier:@"ReceiveDetailKeyValueCell"];
        [self.view addSubview:_tableView];
        
        [ShareOperation shareInstance].viewController = self;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = CGFLOAT_MIN;
    if (section == 0) {
        height = [ReceiveDetailHeaderView height];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if (indexPath.row == 0) {
        height = cellHeight2 + 10;
    } else {
        height = cellHeight2;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + _dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    __weak typeof(self) weakself = self;
    ReceiveDetailHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ReceiveDetailHeaderView"];
    view.publicBlock = ^(BOOL public) {
        [weakself handlePublic:public];
    };
    [view setContent:_cardModel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell;
    if (indexPath.row == 0) {
        ReceiveDetailUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveDetailUserCell" forIndexPath:indexPath];
        [Constants setHeaderImageView:cell.headerImageView path:_cardModel.sender_icon];
        cell.nameLabel.text = _cardModel.sender_nickname;
        
        theCell = cell;
    } else {
        NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row - 1];
        
        ReceiveDetailKeyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveDetailKeyValueCell" forIndexPath:indexPath];
        cell.keyLabel.text = [dic objectForKey:@"key"];
        cell.valueLabel.text = [dic objectForKey:@"value"];
        theCell = cell;
    }
    return theCell;
}
- (void)handlePublic:(BOOL)public
{
    if (public) {
        [self setRightButton:[UIImage imageNamed:@"nav-right-comment"] target:self selector:@selector(showDetail)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)showDetail
{
    CommunityDetailViewController *viewController = [[CommunityDetailViewController alloc] init];
    viewController.cardId = _cardId;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
