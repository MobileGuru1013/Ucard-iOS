//
//  CommunityViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/4/11.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityCollectionViewCell.h"
#import "CommunityDetailViewController.h"
#import "SettingsViewController.h"

@interface CommunityViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *_dataArray;
}
@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRightButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"ReloadCommunityNotification" object:nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 3;
    flowLayout.minimumLineSpacing = 3;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    CGRect frame = _collectionView.frame;
    frame.size.height -= 60;
    _collectionView.frame = frame;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[CommunityCollectionViewCell class] forCellWithReuseIdentifier:@"CommunityCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadCommunityNotification" object:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityDetaiModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    CommunityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommunityCollectionViewCell" forIndexPath:indexPath];
    cell.priseLabel.text = [NSString stringWithFormat:@"%ld", (long)model.like_number];
    cell.commentLabel.text = [NSString stringWithFormat:@"%ld", (long)model.postcard_comment_number];
    cell.countryLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"localized106", nil),model.original_country];
    [Constants setImageView:cell.imageView path:model.postcard_head];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([CommunityCollectionViewCell width], (kCardHeight / kCardWidth) * [CommunityCollectionViewCell width]);
}

- (void)showSettings:(UIButton *)button
{
    SettingsViewController *viewController = [[SettingsViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.title = [button titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityDetaiModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    CommunityDetailViewController *viewController = [[CommunityDetailViewController alloc] init];
    viewController.cardId = model.postcard_uid;
    viewController.listModel = model;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)getData
{
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            NSArray *array = [result objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                _dataArray = [CommunityDetaiModel arrayOfModelsFromDictionaries:array];
            }
            [_collectionView reloadData];
        }
    }];
    [request getPublicList];
}

@end
