//
//  AccountHeaderCell.m
//  Ucard
//
//  Created by Conner Wu on 15/5/7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "AccountHeaderCell.h"
#import "UIView+Frame.h"
#import "ConfigModel.h"
#import  "ProfileViewController.h"

@interface AccountHeaderCell ()
{
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_friendLabel;
    UIImageView *_redImageView;
}
@end

@implementation AccountHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNicknameHeader) name:@"ReloadNicknameHeader" object:nil];
        
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        editButton.frame = CGRectMake(0, 20, 100, 40);
        editButton.titleLabel.font = [UIFont systemFontOfSize:17];
        editButton.tag = 80;
        editButton.hidden = YES;
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editButton setTitle:NSLocalizedString(@"localized052", nil) forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editButton];
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2, 25, 100, 100)];
        _headerImageView.image = [UIImage imageNamed:@"account-header-default"];
        _headerImageView.layer.cornerRadius = CGRectGetHeight(_headerImageView.frame) / 2;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.layer.borderColor = kGColor.CGColor;
        _headerImageView.layer.borderWidth = 2;
        [_headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editProfileTap:)]];
        [self.contentView addSubview:_headerImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, CGRectGetMaxY(_headerImageView.frame) + 10, 200, 20)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = kGColor;
        [self.contentView addSubview:_nameLabel];

        _friendLabel = [[UILabel alloc] initWithFrame:_nameLabel.frame];
        _friendLabel.textAlignment = NSTextAlignmentCenter;
        _friendLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170/255.0 alpha:0.8];
        _friendLabel.font = [UIFont systemFontOfSize:13];
        [_friendLabel setFrameOriginY:CGRectGetMaxY(_nameLabel.frame) + 3];
        [self.contentView addSubview:_friendLabel];
        
        UIButton *receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        receiveButton.frame = CGRectMake((kScreenWidth - 110) / 2.0, [AccountHeaderCell height] - 36 - 15, 110.0f, 36);
        receiveButton.layer.cornerRadius = CGRectGetHeight(receiveButton.frame) / 2;
        receiveButton.layer.masksToBounds = YES;
        [receiveButton setTitle:NSLocalizedString(@"localized054", nil) forState:UIControlStateNormal];
        [receiveButton addTarget:self action:@selector(showSearchCard) forControlEvents:UIControlEventTouchUpInside];
        [receiveButton setTitleColor:[UIColor colorWithRed:102.0/255.0 green:201.0/255.0 blue:144/255.0 alpha:0.8] forState:UIControlStateNormal];
        receiveButton.layer.borderColor = kGColor.CGColor;
        receiveButton.layer.borderWidth = 1;
        [self.contentView addSubview:receiveButton];
        
        if (![ConfigModel isReceived]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setReceived) name:kIsReceivedAccountNotification object:nil];
            
            _redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(receiveButton.frame) - ([Constants isCNLanguage] ? 35 : 25), 5, 10.0, 10.0)];
            _redImageView.backgroundColor = kRedColor;
            _redImageView.layer.cornerRadius = CGRectGetWidth(_redImageView.frame) / 2.0;
            [receiveButton addSubview:_redImageView];
        }
        
        [self getUserInfo];
        [self getFriendCount];
    }
    return self;
}

- (void)setReceived
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kIsReceivedAccountNotification object:nil];
    
    [_redImageView removeFromSuperview];
    _redImageView = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadNicknameHeader" object:nil];
}

+ (CGFloat)height
{
    return 230;
}

- (void)editProfileTap:(UIButton *)button
{
    [self editProfile:(UIButton *)[self.contentView viewWithTag:80]];
}

- (void)editProfile:(UIButton *)button
{
    if (self.editProfileBlock) {
        self.editProfileBlock(button);
    }
}

- (void)showSettings:(UIButton *)button
{
    if (self.showSettingsBlock) {
        self.showSettingsBlock(button);
    }
}

- (void)showSearchCard
{
    if (self.showSearchCardBlock) {
        self.showSearchCardBlock();
    }
}

// 获取用户资料
- (void)getUserInfo
{
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            NSError *error;
            NSString *imagePath =  [Singleton shareInstance].user.photo;
//            imagePath = @"http://graph.facebook.com/1087631654581803/picture?type=large";
            [Singleton shareInstance].user = [[UserInfoModel alloc] initWithDictionary:[result objectForKey:@"data"] error:&error];
            if(imagePath && imagePath.length > 0){
                if ( ![Singleton shareInstance].user.photo ||  [Singleton shareInstance].user.photo.length <=0) {
                    [Singleton shareInstance].user.photo = imagePath;
                }
//                [Singleton shareInstance].user.photo = imagePath;
            }
            if (error) {
                NSLog(@"%@", error);
            } else {
                [weakself reloadNicknameHeader];
            }
        }
    }];
    [request getUserInfo];
}

// 获取信友数量
- (void)getFriendCount
{
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            _friendLabel.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"localized055", nil), [result objectForKey:@"data"]];
        }
    }];
    [request getFrindCount];
}

- (void)reloadNicknameHeader
{
    _nameLabel.text = [Singleton shareInstance].user.nickname;

    [Constants setHeaderImageView:_headerImageView path:[Singleton shareInstance].user.photo];
}

@end
