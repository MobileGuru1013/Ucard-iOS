//
//  LocationViewController.m
//  Ucard
//
//  Created by Nguyễn Hữu Dũng on 30/11/2015.
//  Copyright (c) Năm 2015 Ucard. All rights reserved.
//

#import "LocationViewController.h"
#import "KeyValueTableViewCell.h"
#import "ProfileHeaderTableViewCell.h"
#import "KeyValueModel.h"
#import "TextFieldTableViewController.h"
#import "ActionSheetStringPicker.h"
#import "PostcardCountryViewController.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "LocationCellViewController.h"
#import "LocationModel.h"

@interface LocationViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataArray;
    NSMutableArray *_locationArray;
    UITableView *_tableView;
}
@end
int selectID = -1;
int tempID = -1;
int selectedIndex = 0;
@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super hideNavLogo];

    int cellHeight;
    int fontSmall;
    
    if(kR35){
        cellHeight = 35;
        fontSmall = 10;
    }
    else if(kR40){
        cellHeight = 44;
        fontSmall = 13;
    }
    else if(kR47){
        cellHeight = 50;
        fontSmall = 14;
    }
    else if(kR55){
        cellHeight = 60;
        fontSmall = 15;
    }
    
    
    selectID = (int)[Singleton shareInstance].cardModel.location;
    tempID = selectID;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-35, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[LocationCellViewController class] forCellReuseIdentifier:@"LocationCellViewController"];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _locationArray = [[NSMutableArray alloc] initWithCapacity:0];
    _dataArray = @[@{@"text": NSLocalizedString(@"HIDE LOCATION", nil), @"isSelect" : @"NO"},
                   @{@"text": NSLocalizedString(@"LIMERICK", nil), @"isSelect" : @"NO"},
                   @{@"text": NSLocalizedString(@"CLAUGHAUNGAA", nil), @"isSelect" : @"NO"},
                   @{@"text": NSLocalizedString(@"TRAVELODGE", nil), @"isSelect" : @"NO"},
                   @{@"text": NSLocalizedString(@"CLAUGHAUNGAA", nil), @"isSelect" : @"NO"},
                   @{@"text": NSLocalizedString(@"TRAVELODGE", nil), @"isSelect" : @"NO"}];
    [self reloadLocation];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_locationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LocationModel *model = [_locationArray objectAtIndex:indexPath.row];
    LocationCellViewController *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCellViewController" forIndexPath:indexPath];
    cell.locationlb.text = model.location_name;
    //          cell.locationtf.text = [dic objectForKey:@"subtext"];
    UIImageView *accessoryImageView= [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-60,15,20, 20)];
    accessoryImageView.image = [UIImage imageNamed:@"submit_comment.png"];
    if (tempID == (int) model.location_id) {
        selectedIndex = (int ) indexPath.row;
        cell.accessoryView = accessoryImageView;
        cell.locationlb.textColor=[UIColor colorWithRed:120.0/255.0 green:208.0/255.0 blue:157/255.0 alpha:1.0];
        
    }else {
        
        cell.locationlb.textColor=[UIColor grayColor];
        cell.accessoryView = UITableViewCellAccessoryNone;
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationModel *model = [_locationArray objectAtIndex:indexPath.row];
    if (tempID != (int) model.location_id) {
        tempID = (int) model.location_id;
        selectedIndex = (int) indexPath.row;
        [tableView reloadData];
    }
}
- (void)reloadLocation
{
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            
            LocationModel *model = [[LocationModel alloc] init];
            model.location_id = 0;
            model.location_name = @"HIDE LOCATION";
            model.location_country = @"IE";
            [_locationArray addObject:model];
            @try {
                for (int i = 0; i < [result count]; i++) {
                    NSDictionary *dic = [result objectAtIndex:i];
                    model = [[LocationModel alloc] init];
                    model.location_id = [dic objectForKey:@"Id"];
                    model.location_name = [dic objectForKey:@"Name"];
                    model.location_country = [dic objectForKey:@"CountryCode"];
                    [_locationArray addObject:model];
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            [_tableView reloadData];
        }
    }];
    [request getLocationList:YES];
}
- (void)getLocation:(BOOL)forCount
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goBack
{   if (tempID == selectID) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (self.updateLocation) {
        selectID = tempID;
        [Singleton shareInstance].cardModel.location = selectID;
        LocationModel *model = [_locationArray objectAtIndex:selectedIndex];
        if (selectID == 0) {
            [Singleton shareInstance].cardModel.locationName = @"";
        } else {
            
            [Singleton shareInstance].cardModel.locationName = model.location_name;
        }
        [Singleton shareInstance].cardModel.hasUploaded = NO;
        [[Singleton shareInstance].cardModel updateData];
        self.updateLocation();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end