//
//  SettingsViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "AccountInfoViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "KeyValueTableViewCell.h"
#import "NotificationsViewController.h"

#import "LocationViewController.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSArray *_dataArray;
    
}
@end

int cellHeight4 = 60;
@implementation SettingsViewController

int headerHeight;
UIImageView *headerImageView;
UIView *headerView;
UILabel *nameLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavLogo];
    int fontSmall;
    if(kR35){
        cellHeight4 = 35;
        fontSmall = 13;
    }
    else if(kR40){
        cellHeight4 = 44;
        fontSmall = 15;
    }
    else if(kR47){
        cellHeight4 = 50;
        fontSmall = 16;
    }
    else if(kR55){
        cellHeight4 = 60;
        fontSmall = 17;
    }
    _dataArray = @[@{@"text": NSLocalizedString(@"localized061", nil), @"sel": @"showEditProfile:"},
                     @{@"text": NSLocalizedString(@"localized062", nil), @"sel": @"showAccountInfo:"},
                     @{@"text": NSLocalizedString(@"localized064", nil), @"sel": @"showHelp:"},
                     @{@"text": NSLocalizedString(@"localized063", nil), @"sel": @"showAbout:"},
                     @{@"text": NSLocalizedString(@"localized065", nil), @"sel": @"showFeedback:"}];
    headerHeight = kScreenHeight / 4 + 20;
    if (headerHeight < 180) {
        headerHeight = 180;
    }
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerHeight)];
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2, (headerHeight - 140) / 2, 100, 100)];
    headerImageView.image = [UIImage imageNamed:@"account-header-default"];
    headerImageView.layer.cornerRadius = CGRectGetHeight(headerImageView.frame) / 2;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.userInteractionEnabled = YES;
    [headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editProfileTap)]];

    
    [headerView addSubview:headerImageView];
    headerView.backgroundColor = [UIColor whiteColor];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, CGRectGetMaxY(headerImageView.frame) + 10, 200, 30)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:fontSmall];
    nameLabel.textColor = kGColor;
    [headerView addSubview: nameLabel];
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, kScreenWidth, 1)];
    separatorView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0].CGColor;
    separatorView.layer.borderWidth = 1.0;
    [headerView addSubview:separatorView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), kScreenWidth, cellHeight4 * 5) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[KeyValueTableViewCell class] forCellReuseIdentifier:@"KeyValueTableViewCell"];
    
    UIButton *logoutBtt = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtt addTarget:self
                  action:@selector(showSignin:)forControlEvents:UIControlEventTouchUpInside];
    [logoutBtt setTitle:@"Logout" forState:UIControlStateNormal];
    int tableMaxY = CGRectGetMaxY(tableView.frame);
    int deltaH = self.view.frame.size.height - 60 - tableMaxY;
    int margin = (deltaH - 40) / 2;
    logoutBtt.frame =CGRectMake(20,tableMaxY + margin,kScreenWidth-20 * 2 , 40);
    logoutBtt.backgroundColor=kGColor;
    logoutBtt.layer.cornerRadius =  4;
    logoutBtt.layer.borderColor = [UIColor colorWithRed:0.9020 green:0.9020 blue:0.9020 alpha:1.0000].CGColor;
    logoutBtt.layer.borderWidth = 1;
    logoutBtt.titleLabel.font = [UIFont systemFontOfSize:fontSmall];
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0];
    CGRect b = logoutBtt.frame;
    [self.view addSubview:tableView];
    [self.view addSubview:headerView];
    [self.view addSubview:logoutBtt];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.isNavigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
    NSDictionary *dic = [[Singleton shareInstance].user toDictionary];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dic error:nil];
    [Constants setHeaderImageView:headerImageView path:[Singleton shareInstance].user.photo];
    nameLabel.text = model.nickname;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    
    
    KeyValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KeyValueTableViewCell" forIndexPath:indexPath];
    cell.keyLabel.text = [dic objectForKey:@"text"];
    cell.keyLabel.textColor = [UIColor lightGrayColor];
    cell.keyLabel.textAlignment = NSTextAlignmentLeft;
    cell.valueLabel.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    SEL methodName = NSSelectorFromString([dic objectForKey:@"sel"]);
    if ([self respondsToSelector:methodName]) {
#pragma clang diagnositc push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:methodName withObject:indexPath];
#pragma clang diagnostic pop
    }
}

- (NSString *)getText:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    NSString *text = [dic objectForKey:@"text"];
    return text;
}

- (void)showEditProfile:(NSIndexPath *)indexPath
{
    ProfileViewController *viewController = [[ProfileViewController alloc] init];
    viewController.title = [self getText:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)showAccountInfo:(NSIndexPath *)indexPath
{
    AccountInfoViewController *viewController = [[AccountInfoViewController alloc] init];
    viewController.title = [self getText:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showAbout:(NSIndexPath *)indexPath
{
    AboutViewController *viewController = [[AboutViewController alloc] init];
    viewController.title = [self getText:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showHelp:(NSIndexPath *)indexPath
{
    NotificationsViewController *viewController = [[NotificationsViewController alloc] init];
    viewController.title = [self getText:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];

}

- (void)showFeedback:(NSIndexPath *)indexPath
{
    [self showHelpForm:indexPath isFeedback:YES];
}

- (void)showHelpForm:(NSIndexPath *)indexPath isFeedback:(BOOL)isFeedback
{
    HelpViewController *viewController = [[HelpViewController alloc] init];
    viewController.title = [self getText:indexPath];
    viewController.isFeedback = isFeedback;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showSignout:(NSIndexPath *)indexPath
{
    [UserModel destory];
    
    [[AppDelegate shareDelegate] setRootSignup];
}

- (void)showSignin:(NSIndexPath *)indexPath
{
    [UserModel destory];
    
    [[AppDelegate shareDelegate] setRootSignin];
}

// 调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject:NSLocalizedString(@"localized200", nil)];
    
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject:kSupportEmail];
    [mailPicker setToRecipients:toRecipients];
    
    NSString *emailBody = @"";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    NSLog(@"%@", msg);
}

- (void)editProfileTap
{
    
    ProfileViewController *viewController = [[ProfileViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
