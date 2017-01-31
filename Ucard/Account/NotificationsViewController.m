//
//  NotificationsViewController.m
//  Ucard
//
//  Created by Nguyễn Hữu Dũng on 30/11/2015.
//  Copyright (c) Năm 2015 Ucard. All rights reserved.
//

#import "NotificationsViewController.h"

#import <CFNetwork/CFNetwork.h>
#import "SKPSMTPMessage.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "GCPlaceholderTextView.h"
#import "NSData+Base64Additions.h"
#import "SVProgressHUD.h"
#import "SettingsViewController.h"
#import "AccountViewController.h"
#import "UserModel.h"

@interface NotificationsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIButton *commentbt;
    UIButton *likebt;
    UIButton *recivebt;
    
}
@end

@implementation NotificationsViewController

UserModel *userModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0];
    userModel = [UserModel getAccountModel];
    [self initview];
    [self hideNavLogo];
    [self showNotifocations];
    
}

-(void) initview {

    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,((kR35|| kR40) ? 50 :80))];
    commentView.backgroundColor=[UIColor whiteColor];
    
    UILabel *commentlb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,200, ((kR35|| kR40) ? 50 :80))];
    commentlb.text=@"Comments Update";
    
    commentbt = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-((kR35|| kR40) ? 70 :90),((kR35|| kR40) ? 10 :20),((kR35|| kR40) ? 50 :80), ((kR35|| kR40)? 30 :40))];
    
    [commentbt setImage:[UIImage imageNamed:@"notification_off"] forState:UIControlStateNormal];
    [commentbt setImage:[UIImage imageNamed:@"notifications_on"] forState:UIControlStateSelected];
    [commentbt addTarget:self action:@selector(commentChange) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *likeview = [[UIView alloc] initWithFrame:CGRectMake(0,((kR35|| kR40) ? 50 :80)+1, kScreenWidth, ((kR35|| kR40) ? 50 :80))];
    likeview.backgroundColor=[UIColor whiteColor];
    
    UILabel *likelb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,200, ((kR35|| kR40)? 50 :80))];
    likelb.text=@"Like Update";
    
    likebt = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-((kR35|| kR40)? 70 :90),((kR35|| kR40) ? 10 :20),((kR35|| kR40) ? 50 :80), ((kR35|| kR40) ? 30 :40))];
    [likebt setImage:[UIImage imageNamed:@"notification_off"] forState:UIControlStateNormal];
     [likebt setImage:[UIImage imageNamed:@"notifications_on"] forState:UIControlStateSelected];
      [likebt addTarget:self action:@selector(likeChange) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *reciveview = [[UIView alloc] initWithFrame:CGRectMake(0,((kR35|| kR40) ? 50 :80)*2+1+1, kScreenWidth,((kR35|| kR40) ? 50 :80))];
    reciveview.backgroundColor=[UIColor whiteColor];
    
    UILabel *recivelb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,200, ((kR35|| kR40) ? 50 :80))];
    recivelb.text=@"Recive Update";
    
   recivebt = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-((kR35|| kR40) ? 70 :90),((kR35|| kR40) ? 10 :20),((kR35|| kR40) ? 50 :80),((kR35|| kR40) ? 30 :40))];
    [recivebt setImage:[UIImage imageNamed:@"notifications_on"] forState:UIControlStateSelected];
    [recivebt setImage:[UIImage imageNamed:@"notification_off"] forState:UIControlStateNormal];
    [recivebt addTarget:self action:@selector(receivedChange) forControlEvents:UIControlEventTouchUpInside];
    
    [reciveview addSubview:recivebt];
    [reciveview addSubview:recivelb];
    [self.view addSubview:reciveview];
    
    [likeview addSubview:likebt];
    [likeview addSubview:likelb];
    [self.view addSubview:likeview];
    
    [commentView addSubview:commentbt];
    [commentView addSubview:commentlb];
    [self.view addSubview:commentView];
    commentbt.selected = ((int)userModel.commentNoti == 1);
    likebt.selected = ((int)userModel.likeNoti == 1);
    recivebt.selected = ((int)userModel.receivedNoti == 1);
    
}


-(void) commentChange {


    NSUserDefaults *defaults =[ NSUserDefaults  standardUserDefaults];
    commentbt.selected = !commentbt.selected;
    if (commentbt.selected) {
        userModel.commentNoti = 1;
    } else {
        userModel.commentNoti = 0;
    }
    [userModel updateData];
    [defaults synchronize] ;
}
    
-(void) likeChange {
    
    
    NSUserDefaults *defaults =[ NSUserDefaults  standardUserDefaults];
    likebt.selected = !likebt.selected;
    if (likebt.selected) {
        userModel.likeNoti = 1;
    } else {
        userModel.likeNoti = 0;
    }
    [userModel updateData];
    [defaults synchronize] ;
}
-(void) receivedChange {
    
    
    NSUserDefaults *defaults =[ NSUserDefaults  standardUserDefaults];
    recivebt.selected = !recivebt.selected;
    if (recivebt.selected) {
        userModel.receivedNoti = 1;
    } else {
        userModel.receivedNoti = 0;
    }
    [userModel updateData];
    [defaults synchronize] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
