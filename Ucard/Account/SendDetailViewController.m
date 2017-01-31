//
//  SendDetailViewController.m
//  Ucard
//
//  Created by Conner Wu on 15/5/8.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SendDetailViewController.h"
#import "ReceiveDetailKeyValueCell.h"
#import "SendDetailHeaderView.h"
#import "CommunityDetailViewController.h"

@interface SendDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataArray;
    SendDetailModel *_cardModel;
    UITableView *_tableView;
}
@end

@implementation SendDetailViewController
int cellHeight3 = 60;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRightButton];
    int fontSmall;
    if(kR35){
        cellHeight3 = 35;
        fontSmall = 13;
    }
    else if(kR40){
        cellHeight3 = 44;
        fontSmall = 15;
    }
    else if(kR47){
        cellHeight3 = 50;
        fontSmall = 16;
    }
    else if(kR55){
        cellHeight3 = 60;
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
            _cardModel = [[SendDetailModel alloc] initWithDictionary:[result objectForKey:@"data"] error:&error];
            if (_cardModel) {
                _cardModel.postcard_id = _cardId;
                [weakself showData];
                
                if (_cardModel.sharing_state != 1) {
                    [self setRightButton:[UIImage imageNamed:@"nav-right-comment"] target:self selector:@selector(showDetail)];
                }
            } else {
                NSLog(@"%@", error);
            }
        }
    }];
    [request getSendCardDetail:_cardId];
}

- (void)showData
{
    if (!_cardModel) {
        return;
    }
    
    _dataArray = @[@{@"key": NSLocalizedString(@"localized099", nil), @"value": [Constants handleString:_cardModel.postcard_id]},
                     @{@"key": NSLocalizedString(@"localized100", nil), @"value": [Constants getLocalizedCountry:[Constants handleString:_cardModel.original_country]]},
                     @{@"key": NSLocalizedString(@"localized101", nil), @"value": [NSString stringWithFormat:@"%@ %@", [Constants handleString:_cardModel.price], [Constants handleString:_cardModel.currency]]},
                     @{@"key": NSLocalizedString(@"localized102", nil), @"value": [Constants handleString:_cardModel.payment_type]},
                     @{@"key": NSLocalizedString(@"localized103", nil), @"value": [Constants handleString:_cardModel.record_uid]},
                     @{@"key": NSLocalizedString(@"localized104", nil), @"value": [Constants handleString:_cardModel.postcard_making_time]}];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SendDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"SendDetailHeaderView"];
        [_tableView registerClass:[ReceiveDetailKeyValueCell class] forCellReuseIdentifier:@"ReceiveDetailKeyValueCell"];
        [self.view addSubview:_tableView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 20;
    if (section == 0) {
        height = [SendDetailHeaderView height];
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight3;
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
    return [_dataArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        SendDetailHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SendDetailHeaderView"];
        [view setContent:_cardModel];
        return view;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    
    ReceiveDetailKeyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveDetailKeyValueCell" forIndexPath:indexPath];
    cell.keyLabel.text = [dic objectForKey:@"key"];
    cell.valueLabel.text = [dic objectForKey:@"value"];
    
    return cell;
}

- (void)showDetail
{
    CommunityDetailViewController *viewController = [[CommunityDetailViewController alloc] init];
    viewController.cardId = _cardId;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
