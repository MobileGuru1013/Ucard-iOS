//
//  SigninBaseViewController.m
//  Ucard
//
//  Created by Conner Wu on 15-4-7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "WeiboSDK.h"

#import "AppDelegate.h"
#import "SigninBaseViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UserModel.h"
#import "NicknameViewController.h"
#import "SigninViewController.h"
#import "SignupViewController.h"
#import "CustomIOSAlertView.h"
#import "SDImageCache.h"

@interface SigninBaseViewController ()
{
    NicknameViewController *_nicknameViewController;
    SigninViewController *signin;
    SignupViewController *signup;
}
@end

@implementation SigninBaseViewController
NSString * username;
NSString * email;
NSString * udid;
NSString * imagePath;
CustomIOSAlertView * dialog;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(kR35 || kR40){
        fontNormal = 13;
        fontSmall = 11;
    } else if(kR47){
        fontNormal = 15;
        fontSmall = 11;
        
    } else if(kR55){
        fontNormal = 15;
        fontSmall = 11;
        
    }
    CGFloat height;
    CGFloat width2;
    
    if(kR35) height = 55;
    else if(kR40) height = 55;
    else if(kR47) height = 85;
    else if(kR55) height = 95;
    
    if(kR35) width2 = 120;
    else if(kR40) width2 = 120;
    else if(kR47) width2 = 150;
    else if(kR55) width2 = 180;
    
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbProfileComplete) name:FBSDKProfileDidChangeNotification object:nil];
    
    self.view = [[TPKeyboardAvoidingScrollView alloc] init];
    
    backgroundview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight )];
    backgroundview.image = [UIImage imageNamed:@"0_Launch.png"];
    [self.view addSubview:backgroundview];
    self.view.backgroundColor = [UIColor whiteColor];
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2, height , 100 , 100)];
    _logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_logoImageView];
    
    viewpoop=[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50 , kScreenWidth, 50 ) ];
    _tipsLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0, kScreenWidth-width2 , 50)];
    _tipsLabel.textColor = kTextGrayColor;
    _tipsLabel.textAlignment = NSTextAlignmentRight;
    _tipsLabel.font = [UIFont boldSystemFontOfSize:fontNormal];
    
    
    _tipsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _tipsButton.frame = CGRectMake(CGRectGetMaxX(_tipsLabel.frame), CGRectGetMinY(_tipsLabel.frame) - 15, 50, CGRectGetHeight(_tipsLabel.frame) + 15 * 2);
    _tipsButton.titleLabel.font = _tipsLabel.font;
    [_tipsButton setTitleColor:kGColor forState:UIControlStateNormal];
    [_tipsButton setFont:[UIFont boldSystemFontOfSize:fontNormal]];
    
    
    viewpoop.backgroundColor=[UIColor whiteColor];
    [viewpoop addSubview:_tipsButton];
    [viewpoop addSubview:_tipsLabel];
    [self.view addSubview:viewpoop];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createOtherView:(NSString *)title sel:(SEL)sel signup:(BOOL)signup
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_logoImageView.frame) + (kR35 ? 15 : 50), kScreenWidth -40, _dataArray.count * 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor yellowColor];
    [_tableView registerClass:[SignupTableViewCell class] forCellReuseIdentifier:@"SignupTableViewCell"];
    [self.view addSubview:_tableView];
    _signButton = [Constants createGreenButton:CGRectMake(20, CGRectGetMaxY(_tableView.frame) + 20, kScreenWidth - 20 * 2, 44) title:title sel:sel target:self];
    
    [self.view addSubview:_signButton];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_signButton.frame) + (kR35 ? 30 :50) + (signup ? 20 : 0), kScreenWidth, 20)];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:fontNormal];
    tipsLabel.text = NSLocalizedString(@"localized005", nil);
    int tipWidth;
    int lineWidth;
    int marginTip = 20;
    [tipsLabel sizeToFit];
    tipWidth = tipsLabel.frame.size.width;
    lineWidth = (_tableView.frame.size.width - 20 * 2 - tipWidth - 2 * marginTip) / 2;
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(_tableView.frame.origin.x + 20, tipsLabel.frame.origin.y + 9, lineWidth, 1)];
    line1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line1];
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tableView.frame) -20 - lineWidth, tipsLabel.frame.origin.y + 9, lineWidth, 1)];
    line2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line2];
    CGRect frame = tipsLabel.frame;
    frame.origin.x = CGRectGetMaxX(line1.frame) + marginTip;
    tipsLabel.frame = frame;
    [self.view addSubview:tipsLabel];
    
    
    NSArray *array = @[@{@"image": @"facebook", @"sel": @"facebook"},
                       @{@"image": @"Weibo", @"sel": @"Weibo"}];
    
    CGFloat width = 55;
    CGFloat margin = 55;
    CGFloat height = 35;
    if(kR35) width = 55;
    
    else if(kR40) width = 55;
    
    else if(kR47) {
        height = 45;
        width = 75;
    }
    else if(kR55) {
        height = 50;
        width = 90;
    }

    
    CGFloat marginLeft = (kScreenWidth - array.count * width - (array.count - 1) * margin) /5;
    for (NSUInteger i = 0; i < array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame =CGRectMake(marginLeft + (width + 25 + margin) *i, CGRectGetMaxY(tipsLabel.frame) + (kR35 ? 5 : 15),width + 75, height);
        
        button.frame =  frame;
        [button setImage:[UIImage imageNamed:[dic objectForKey:@"image"]] forState:UIControlStateNormal];
        [button addTarget:self action:NSSelectorFromString([dic objectForKey:@"sel"]) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        if (checked==signup) {
            [tipsLabel setHidden:NO];
            [button setHidden:NO];
            line1.hidden = NO;
            line2.hidden = NO;
        }
        else
            if(checked==signin) {
                [tipsLabel setHidden:YES];
                line1.hidden = YES;
                line2.hidden = YES;
                [button setHidden:YES];
            }
        
    }
}

#pragma mark Facebook登录

- (void)facebook
{
    [[Singleton shareInstance] startLoadingInView:self.view];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        // Facebook app is installed
        login.loginBehavior = FBSDKLoginBehaviorNative;
    } else login.loginBehavior = FBSDKLoginBehaviorWeb;
    [login logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [[Singleton shareInstance] stopLoading];
        } else if (result.isCancelled) {
            [[Singleton shareInstance] stopLoading];
        } else {
            if ([FBSDKAccessToken currentAccessToken]) {
                NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                [parameters setValue:@"id,name,email,picture.type(square)" forKey:@"fields"];
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         email = [result objectForKey:@"email"];
                         username = [result objectForKey:@"name"];
                         udid = [result objectForKey:@"id"];
                         imagePath = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                         [self checkSNS:@"facebook" uid:udid nickname:username andEmail:email andImagePath:imagePath];
                     }
                 }];
            }
        }
    }];
}

- (void)fbProfileComplete
{
    [[Singleton shareInstance] stopLoading];
    
    FBSDKProfile *profile = [FBSDKProfile currentProfile];
}

#pragma mark 新浪登录


- (void)Weibo

{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWeiboRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
    
}

// 登录
- (void)signinMethod:(NSString *)user password:(NSString *)password
{
    self.view.userInteractionEnabled = NO;
    [_signButton startLoading];
    
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request completion:^(id result, BOOL succ) {
        self.view.userInteractionEnabled = YES;
        [_signButton stopLoading];
        if (succ) {
            [UserModel signinSucceed:[[result objectForKey:@"data"] objectForKey:@"uuid"] user:user password:password type:@"email"];
            [[AppDelegate shareDelegate] setRootHome];
        } else {
            if (_coverImageView) {
                if ([self respondsToSelector:@selector(showSignin:)]) {
                    [self performSelector:@selector(showSignin:) withObject:[NSNumber numberWithBool:NO] afterDelay:CGFLOAT_MIN];
                    
                    [_coverImageView removeFromSuperview];
                }
            }
        }
    }];
    
    [request signin:user password:password];
    
}


// 检测第三方账号是否已注册
- (void)checkSNS:(NSString *)type uid:(NSString *)uid nickname:(NSString *)nickname andEmail: (NSString *) _email andImagePath: (NSString *) _imagePath
{
    email = _email;
    udid = uid;
    username = nickname;
    imagePath = _imagePath;
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            // 账号没注册，填写昵称后注册
            if (!email || email.length <= 0) {
                if ([type isEqualToString:@"weibo"]) {
                    [self showAlertWeibo:nickname andUDID:uid];
                } else {
                    [self showAlertFacebook:nickname andUDID:uid];
                }
            } else {
                email = _email;
                [weakself showNicknameViewController:type uid:uid nickname:nickname];
            }
        } else {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dicResult = (NSDictionary *)result;
                NSArray *allKeys = [dicResult allKeys];
                if ([allKeys containsObject:kHttpReturnCodeKey]) {
                    NSNumber *code = [dicResult objectForKey:kHttpReturnCodeKey];
                    if ([code isEqualToNumber:@10]) {
                        // 已注册过了，登录
                        [weakself signinSNS:type uid:uid button:nil];
                    } else {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                            message:[result objectForKey:@"message"]
                                                                           delegate:nil
                                                                  cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                                  otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                }
            }
        }
    }];
    [request checkSNS:type uid:udid andEmail:email];
}

// 第三方注册前填写昵称
- (void)showNicknameViewController:(NSString *)type uid:(NSString *)uid nickname:(NSString *)nickname
{
    [self signupSNS:type uid:uid nickname:nickname button:_signButton];
}

// 关闭填写昵称界面
- (void)closeNickname
{
    if (!_nicknameViewController) {
        return;
    }
    
    CGRect frame = _nicknameViewController.view.bounds;
    frame.origin.y = CGRectGetHeight(frame);
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         _nicknameViewController.view.frame = frame;
                     } completion:^(BOOL finished) {
                         [_nicknameViewController.view removeFromSuperview];
                         _nicknameViewController = nil;
                     }];
}

// 第三方注册
- (void)signupSNS:(NSString *)type uid:(NSString *)uid nickname:(NSString *)nickname button:(ActivityButton *)button
{
    [button startLoading];
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [UserModel signinSucceed:[result objectForKey:@"data"] user:uid password:nil type:type];
            [[AppDelegate shareDelegate] setRootHome];
        } else {
            [button stopLoading];
            
            [weakself closeNickname];
        }
    }];
    [request signupSNS:type uid:uid nickname:nickname email:email];
}



// 第三方登录
- (void)signinSNS:(NSString *)type uid:(NSString *)uid button:(ActivityButton *)button
{
    if (button) {
        [button startLoading];
    }
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request completion:^(id result, BOOL succ) {
        if (button) {
            [button stopLoading];
        }
        if (succ) {
            [UserModel signinSucceed:[result objectForKey:@"data"] user:uid password:nil type:type];
            [[AppDelegate shareDelegate] setRootHome];
            if (imagePath && imagePath.length > 0)
                [self photoSelected:imagePath];
        } else {
            [weakself closeNickname];
            
            if (_coverImageView) {
                if ([self respondsToSelector:@selector(showSignin:)]) {
                    [self performSelector:@selector(showSignin:) withObject:[NSNumber numberWithBool:NO] afterDelay:CGFLOAT_MIN];
                }
                
                [_coverImageView removeFromSuperview];
            }
        }
    }];
    [request signinSNS:type uid:uid showLoading:button ? NO : YES];
}
-(void) showAlertFacebook: (NSString *) _username andUDID: (NSString *) _udid{
    username = _username;
    udid = _udid;
    CGFloat width1 = 110;
    if(kR35) width1 = 70;
    else if(kR40) width1 = 110;
    else if(kR47) width1 = 160;
    else if(kR55) width1= 200;
    else width1 = 100;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-width1, 60 * 3 + 20)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, view.frame.size.width-60, 40)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"Facebook Login";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    _textField = [[UITextField alloc] initWithFrame: CGRectMake(30, CGRectGetMaxY(titleLabel.frame) + 20, view.frame.size.width-60, 40)];
    _textField.backgroundColor=[UIColor whiteColor];
    _textField.delegate = self;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, _textField.frame.size.height)];
    [_textField setLeftViewMode:UITextFieldViewModeAlways];
    [_textField setLeftView:paddingView];
    [_textField setAlpha:1];
    _textField.layer.cornerRadius = 4;
    _textField.layer.borderColor =[UIColor grayColor].CGColor;
    _textField.layer.borderWidth =0.4;
    _textField.placeholder= NSLocalizedString(@"localized001",nil);
     _textField.tag = 4;
//    [_textField becomeFirstResponder];
    _textField.textColor = [UIColor grayColor];
    [_textField setFont:[UIFont boldSystemFontOfSize:fontNormal]];
    
    
    _submitButton = [ActivityButton buttonWithType:UIButtonTypeCustom];
    [_submitButton addTarget:self
                      action:@selector(onSubmitClickFB)forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    
    _submitButton.frame = CGRectMake(30,CGRectGetMaxY(_textField.frame) + 20, view.frame.size.width-60, 40);
    _submitButton.backgroundColor=kGColor;
    _submitButton.layer.cornerRadius =  4;
    _submitButton.layer.borderColor = [UIColor colorWithRed:0.9020 green:0.9020 blue:0.9020 alpha:1.0000].CGColor;
    _submitButton.layer.borderWidth = 1;
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:titleLabel];
    [view addSubview:_submitButton];
    [view addSubview:_textField];
    view.backgroundColor = [UIColor whiteColor];
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    UIView *rootView;
    rootView = view;
    CGRect frame = rootView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [rootView setFrame:frame];
    CGFloat cornerRadius = 8;
    rootView.layer.cornerRadius = cornerRadius;
    alertView.backgroundColor = [UIColor clearColor];
    [alertView setContainerView: rootView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [alertView setUseMotionEffects:true];
    // And launch the dialog
    [alertView show];
    dialog = alertView;
    
    
}
-(void) showAlertWeibo: (NSString *) _username andUDID: (NSString *) _udid{
    username = _username;
    udid = _udid;
    CGFloat width1 = 110;
    if(kR35) width1 = 70;
    else if(kR40) width1 = 110;
    else if(kR47) width1 = 160;
    else if(kR55) width1= 200;
    else width1 = 100;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-width1, 60 * 3 + 20)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, view.frame.size.width-60, 40)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"Weibo Login";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    _textField = [[UITextField alloc] initWithFrame: CGRectMake(30, CGRectGetMaxY(titleLabel.frame) + 20, view.frame.size.width-60, 40)];
    _textField.backgroundColor=[UIColor whiteColor];
    _textField.delegate = self;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, _textField.frame.size.height)];
    [_textField setLeftViewMode:UITextFieldViewModeAlways];
    [_textField setLeftView:paddingView];
    [_textField setAlpha:1];
    _textField.layer.cornerRadius = 4;
    _textField.layer.borderColor =[UIColor grayColor].CGColor;
    _textField.layer.borderWidth =0.4;
    _textField.placeholder=NSLocalizedString(@"localized001",nil);
       _textField.tag = 3;
//    [_textField becomeFirstResponder];
    _textField.textColor = [UIColor grayColor];
    [_textField setFont:[UIFont boldSystemFontOfSize:fontNormal]];
    
    
    _submitButton = [ActivityButton buttonWithType:UIButtonTypeCustom];
    [_submitButton addTarget:self
                      action:@selector(onSubmitClick)forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setTitle:NSLocalizedString(@"localized022",nil) forState:UIControlStateNormal];
    
    _submitButton.frame = CGRectMake(30,CGRectGetMaxY(_textField.frame) + 20, view.frame.size.width-60, 40);
    _submitButton.backgroundColor=kGColor;
    _submitButton.layer.cornerRadius =  4;
    _submitButton.layer.borderColor = [UIColor colorWithRed:0.9020 green:0.9020 blue:0.9020 alpha:1.0000].CGColor;
    _submitButton.layer.borderWidth = 1;
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:titleLabel];
    [view addSubview:_submitButton];
    [view addSubview:_textField];
    view.backgroundColor = [UIColor whiteColor];
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
//    alertView.parentView = self.view;
    UIView *rootView;
    rootView = view;
    CGRect frame = rootView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [rootView setFrame:frame];
    CGFloat cornerRadius = 8;
    rootView.layer.cornerRadius = cornerRadius;
    alertView.backgroundColor = [UIColor clearColor];
    [alertView setContainerView: rootView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [alertView setUseMotionEffects:true];
    // And launch the dialog
    [alertView show];
    dialog = alertView;
    
    
}
-(void) showForgetPassword{
    
    CGFloat width1 = 110;
    if(kR35) width1 = 110;
    else if(kR40) width1 = 110;
    else if(kR47) width1 = 160;
    else if(kR55) width1= 200;
    else width1 = 100;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-width1, 60 * 3 + 20)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, view.frame.size.width-60, 40)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text =NSLocalizedString( @"localized219",nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _textField = [[UITextField alloc] initWithFrame: CGRectMake(30, CGRectGetMaxY(titleLabel.frame) + 20, view.frame.size.width-60, 40)];
    _textField.backgroundColor=[UIColor whiteColor];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, _textField.frame.size.height)];
    [_textField setLeftViewMode:UITextFieldViewModeAlways];
    [_textField setLeftView:paddingView];
    [_textField setAlpha:1];
    _textField.layer.cornerRadius = 4;
    _textField.layer.borderColor =[UIColor grayColor].CGColor;
    _textField.layer.borderWidth =0.4;
    _textField.placeholder=NSLocalizedString(@"localized001",nil);
    
    _textField.delegate = self;
    _textField.tag = 2;
//    _textField.returnKeyType = UIReturnKeyDone;
//    [_textField setDelegate:self];
//    [_textField becomeFirstResponder];
    _textField.textColor = [UIColor grayColor];
    [_textField setFont:[UIFont boldSystemFontOfSize:fontNormal]];
    
    _submitButton = [ActivityButton buttonWithType:UIButtonTypeCustom];
    [_submitButton addTarget:self
                      action:@selector(submit)forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setTitle:NSLocalizedString(@"localized022",nil) forState:UIControlStateNormal];
    _submitButton.frame = CGRectMake(30,CGRectGetMaxY(_textField.frame) + 20, view.frame.size.width-60, 40);
    _submitButton.backgroundColor=kGColor;
    _submitButton.layer.cornerRadius =  4;
    _submitButton.layer.borderColor = [UIColor colorWithRed:0.9020 green:0.9020 blue:0.9020 alpha:1.0000].CGColor;
    _submitButton.layer.borderWidth = 1;
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:titleLabel];
    [view addSubview:_submitButton];
    [view addSubview:_textField];
    view.backgroundColor = [UIColor whiteColor];
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    UIView *rootView;
    rootView = view;
    CGRect frame = rootView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [rootView setFrame:frame];
    CGFloat cornerRadius = 8;
    rootView.layer.cornerRadius = cornerRadius;
    alertView.backgroundColor = [UIColor clearColor];
    [alertView setContainerView: rootView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [alertView setUseMotionEffects:true];
    // And launch the dialog
    [alertView show];
    dialog = alertView;
    
    
}
- (void) onSubmitClickFB
{
    if (dialog) {
        [dialog close];
    }
    NSString *emailText = _textField.text;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL emailPass = [emailTest evaluateWithObject:emailText];
    NSString *tips;
    if (!email || email.length == 0) {
        tips = NSLocalizedString(@"localized195", nil);
    } else if (!emailPass) {
        tips = NSLocalizedString(@"localized198", nil);
    }
    if (tips) {
        [Constants showTipsMessage:tips];
        
        return;
    } else {
        email = emailText;
    }
    if (email && email.length > 0) {
        [self showNicknameViewController:@"facebook" uid:udid nickname:username];
    } else {
        NSString *text = _textField.text;
        if (!text || text.length == 0) {
            [Constants showTipsMessage:NSLocalizedString(@"localized185", nil)];
            return;
        }
    }
    
}
- (void) onSubmitClick
{
    if (dialog) {
        [dialog close];
    }
    NSString *emailText = _textField.text;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL emailPass = [emailTest evaluateWithObject:emailText];
    NSString *tips;
    if (!email || email.length == 0) {
        tips = NSLocalizedString(@"localized195", nil);
    } else if (!emailPass) {
        tips = NSLocalizedString(@"localized198", nil);
    }
    if (tips) {
        [Constants showTipsMessage:tips];
        
        return;
    } else {
        email = emailText;
    }
    if (email && email.length > 0) {
        [self showNicknameViewController:@"weibo" uid:udid nickname:username];
    } else {
        NSString *text = _textField.text;
        if (!text || text.length == 0) {
            [Constants showTipsMessage:NSLocalizedString(@"localized185", nil)];
            return;
        }
    }
    
}
- (void)submit
{
    if (dialog) {
        [dialog close];
    }
    NSString *text = _textField.text;
    if (!text || text.length == 0) {
        [Constants showTipsMessage:NSLocalizedString(@"localized185", nil)];
        return;
    }
    [_textField resignFirstResponder];
    
    [_submitButton startLoading];
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        [_submitButton stopLoading];
        
        if (succ) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"localized015", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
    [request forgetPassword:text];
}

//-(BOOL) textFieldShouldReturn:(UITextField *)textField{
//    
//    [textField resignFirstResponder];
//    return YES;
//}

#pragma mark 自动登录

- (void)checkAutoSignin
{
    NSArray *array = [UserModel getAccount];
    if (array && array.count == 3) {
        NSString *launchImageName;
        if (kR35) {
            launchImageName = @"LaunchImage-700";
        } else if (kR40) {
            launchImageName = @"LaunchImage-700-568h";
        } else if (kR47) {
            launchImageName = @"LaunchImage-800-667h";
        } else if (kR55) {
            launchImageName = @"LaunchImage-800-Portrait-736h";
        }
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _coverImageView.image = [UIImage imageNamed:launchImageName];
        _coverImageView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_coverImageView];
        
        NSString *user = array[0];
        NSString *password = array[1];
        NSString *type = array[2];
        if ([type isEqualToString:@"email"]) {
            [self signinMethod:user password:password];
        } else {
            [self signinSNS:type uid:user button:nil];
        }
    }
}
- (void)photoSelected:(NSString *) path
{
    NSURL *imageURL = [NSURL URLWithString:path];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
            [request completion:^(id result, BOOL succ) {
                if (succ) {
                    NSString *path = [result objectForKey:@"data"];
                    [[SDImageCache sharedImageCache] removeImageForKey:[Constants getFileURLString:path]
                                                        withCompletion:^{
                                                            [Singleton shareInstance].user.photo = path;

                                                        }];
                }
            }];
            [request submitHeader:[UIImage imageWithData:imageData]];
        });
    });
//    [[SDImageCache sharedImageCache] removeImageForKey:path
//                                        withCompletion:^{
//                                            [Singleton shareInstance].user = [[UserInfoModel alloc] init];
//                                            [Singleton shareInstance].user.photo = path;
//                                        }];
    
}

@end
