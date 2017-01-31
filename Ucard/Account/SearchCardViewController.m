//
//  SearchCardViewController.m
//  Ucard
//
//  Created by Conner Wu on 15/5/6.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SearchCardViewController.h"
#import "SearchCardModel.h"
#import "NSString+TimeAgo.h"
#import "ShareOperation.h"
#import "SVProgressHUD.h"
#import "CustomIOSAlertView.h"

@interface SearchCardViewController () <UISearchBarDelegate>
{
    UIView *_mainBgView;
    UIImageView *_frontView;
    UIImageView *_backView;
    SearchCardModel *_cardModel;
    UIButton *_flipButton;
    UIScrollView *_scrollView;
    UIButton *_handleButton;
    
}
@end

@implementation SearchCardViewController

UISearchBar *searchBar;
CGFloat hmainBgView;
CGFloat wmainBgView;
CGFloat wbutton;
CGFloat wsearch;
int imageWidth;

int fontNormal;
int fontSmall;
CustomIOSAlertView *alertView;
NSString *keyword;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRightButton];
    
    
    if(kR35) wsearch = 45;
    else if(kR40) wsearch =50;
    else if(kR47) wsearch = 50;
    else if(kR55) wsearch = 55;
    
    
    if(kR35) hmainBgView = 10;
    else if(kR40) hmainBgView =20;
    else if(kR47) hmainBgView = 20;
    else if(kR55) hmainBgView = 20;
    
    if(kR35) wmainBgView = 40;
    else if(kR40) wmainBgView =50;
    else if(kR47) wmainBgView = 50;
    else if(kR55) wmainBgView = 70;
    
    if(kR35) wbutton = 180;
    else if(kR40) wbutton =180;
    else if(kR47) wbutton = 220;
    else if(kR55) wbutton = 230;
    
    
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
    imageWidth = kScreenWidth - hmainBgView * 2;
    
    
    self.title = NSLocalizedString(@"localized095", nil);
    UIView * searchBarview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, wsearch)];
    searchBarview.backgroundColor=[UIColor colorWithRed:120.0/255.0 green:208.0/255.0 blue:157/255.0 alpha:1.0];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(hmainBgView+5, 0, kScreenWidth-hmainBgView*2-10, wsearch)];
    searchBar.delegate = self;
    searchBar.placeholder = NSLocalizedString(@"localized096", nil);
    searchBar.barTintColor=[UIColor colorWithRed:120.0/255.0 green:208.0/255.0 blue:157/255.0 alpha:1.0];
    
    [self.view addSubview:searchBarview];
    [searchBarview addSubview:searchBar];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSString *key = searchBar.text;
    keyword = key;
    if (!key || key.length == 0) {
        return;
    }
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        _cardModel = nil;
        if (succ) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"data"]];
            [dic setObject:key forKey:@"postcard_id"];
            NSError *error;
            _cardModel = [[SearchCardModel alloc] initWithDictionary:dic error:&error];
            _cardModel.sharing_state = 1;
            if (error) {
                NSLog(@"%@", error);
            }
        }
        [weakself showCard];
    }];
    [request searchCard:key];
}

- (void)showCard
{
    [self initView];
}
-(void) initView {    CGFloat hmainBgView;
    CGFloat wmainBgView;
    CGFloat wbutton;
    CGFloat wsearch;
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (!_cardModel) {
        [self showDialogError];
        return;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(searchBar.frame))];
    self.view.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:238.0/255.0 blue:235/255.0 alpha:1.0];
    // 正反面父视图
    _mainBgView = [[UIView alloc] initWithFrame:CGRectMake(hmainBgView,5, imageWidth, kCardHeight * imageWidth / kCardWidth)];
    _mainBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    _mainBgView.layer.shadowOpacity = 0.7;
    _mainBgView.layer.shadowOffset = CGSizeMake(0, 0);
    _mainBgView.layer.shadowRadius = 2.0;
    [_scrollView addSubview:_mainBgView];
    
    _backView = [[UIImageView alloc] initWithFrame:_mainBgView.bounds];
    [Constants setImageView:_backView path:_cardModel.postcard_back];
    [_mainBgView addSubview:_backView];
    
    _frontView = [[UIImageView alloc] initWithFrame:_mainBgView.bounds];
    [Constants setImageView:_frontView path:_cardModel.postcard_head];
    [_mainBgView addSubview:_frontView];
    
    
    UIView * viewhandlebt =[[UIView alloc ] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mainBgView.frame) +5, kScreenWidth, wmainBgView)];
    viewhandlebt.backgroundColor=[UIColor whiteColor];
    _handleButton = [Constants createButton:CGRectMake(hmainBgView,5, wbutton, wmainBgView-10) title:NSLocalizedString(@"localized097", nil) target:self sel:@selector(receiveCard) color:kGreenColor];
    _handleButton.layer.cornerRadius = 10;
    _handleButton.layer.borderColor =kGColor.CGColor;
    _handleButton.layer.borderWidth = 1;

    [viewhandlebt addSubview:_handleButton];
    [_scrollView addSubview:viewhandlebt];
    
    
    UIView * viewname =[[UIView alloc ] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewhandlebt.frame) +5, kScreenWidth, wmainBgView)];
    viewname.backgroundColor=[UIColor whiteColor];
    UIImageView * nameim =[[UIImageView alloc ] initWithFrame:CGRectMake(hmainBgView+5,5, wmainBgView-10, wmainBgView-10)];
    nameim.image = [UIImage imageNamed: @"search_name.png"];
    UILabel *namelb=[[UILabel alloc] initWithFrame:CGRectMake (CGRectGetMaxY(nameim.frame)+30,0,200,wmainBgView)];
    namelb.text=_cardModel.sender_nickname;
    namelb.textColor=kGColor;
    namelb.font=[UIFont fontWithName:@"System" size:fontNormal];
    
    [viewname addSubview:namelb];
    [viewname addSubview:nameim];
    [_scrollView addSubview:viewname];
    
    UIView * viewtime =[[UIView alloc ] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewname.frame) +5, kScreenWidth, wmainBgView)];
    viewtime.backgroundColor=[UIColor whiteColor];
    UIImageView * timeim =[[UIImageView alloc ] initWithFrame:CGRectMake(hmainBgView,0, wmainBgView, wmainBgView)];
    timeim.image = [UIImage imageNamed: @"search_time.png"];
    UILabel *timelb=[[UILabel alloc] initWithFrame:CGRectMake (CGRectGetMaxY(timeim.frame)+140,0,200,wmainBgView)];
    timelb.text=[_cardModel.postcard_making_time timeAgo];
    timelb.textColor=[UIColor grayColor];
    timelb.font=[UIFont fontWithName:@"System" size:fontNormal];
    [viewtime addSubview:timelb];
    [viewtime addSubview:timeim];
    [_scrollView addSubview:viewtime];
    
    UIView * viewadd =[[UIView alloc ] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewtime.frame) +5, kScreenWidth, wmainBgView)];
    viewadd.backgroundColor=[UIColor whiteColor];
    UIImageView * addim =[[UIImageView alloc ] initWithFrame:CGRectMake(hmainBgView,0, wmainBgView, wmainBgView)];
    addim.image = [UIImage imageNamed: @"search_address.png"];
    UILabel *addlb=[[UILabel alloc] initWithFrame:CGRectMake (CGRectGetMaxY(addim.frame)+140,0,200,wmainBgView)];
    addlb.text=_cardModel.receiver_country;
    addlb.textColor=[UIColor grayColor];
    addlb.font=[UIFont fontWithName:@"System" size:fontNormal];
    
    [viewadd addSubview:addlb];
    [viewadd addSubview:addim];
    [_scrollView addSubview:viewadd];
    
    [self.view addSubview:_scrollView];
}
-(void) showDialogError {
    UIView * dialogview =[[UIView alloc ] initWithFrame:CGRectMake(hmainBgView,0, imageWidth, kCardHeight * imageWidth / kCardWidth)];
    dialogview.backgroundColor=[UIColor whiteColor];
    UIView * viewtext =[[UIView alloc ] initWithFrame:CGRectMake(10,10, imageWidth-20, wsearch)];
    viewtext.layer.cornerRadius = 8;
    viewtext.layer.borderColor = [UIColor grayColor].CGColor;
    viewtext.layer.borderWidth = 1;
    UITextField *dltextfield =[[UITextField alloc ] initWithFrame:CGRectMake(10,5,CGRectGetWidth(viewtext.frame) - 20 - 10 - wmainBgView, wsearch-10)];
    dltextfield.text = keyword;
    UIButton *dlbutton =[[UIButton alloc ] initWithFrame:CGRectMake(CGRectGetMaxX(dltextfield.frame) + 10,5,wmainBgView, wsearch-10)];
    [dlbutton setTitle:@"GO" forState:UIControlStateNormal];
    [dlbutton addTarget:self
               action:@selector(closeDialog)forControlEvents:UIControlEventTouchUpInside];
    dlbutton.backgroundColor = [UIColor clearColor];
    dlbutton.titleLabel.textAlignment =NSTextAlignmentLeft;
    dlbutton.titleLabel.font = [UIFont systemFontOfSize:fontNormal];
    [dlbutton setTitleColor:[UIColor colorWithRed:120.0/255.0 green:208.0/255.0 blue:157/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    
    UILabel *dllabel =[[UILabel alloc ] initWithFrame:CGRectMake(20,CGRectGetMaxY(viewtext.frame) + 20,imageWidth-40, kCardHeight * imageWidth / kCardWidth - CGRectGetMaxY(viewtext.frame) -40)];
    dllabel.text=@"Woops...This postcard does not exist \n.Please check the postcard id again";
    dllabel.textColor =[UIColor redColor];
    dllabel.numberOfLines = 0;
    dllabel.font=[UIFont fontWithName:@"System" size:fontNormal];
    dllabel.textAlignment = NSTextAlignmentCenter;
    [dialogview addSubview:dllabel];
    [viewtext addSubview:dlbutton];
    [viewtext addSubview:dltextfield];
    [dialogview addSubview:viewtext];
    
    alertView = [[CustomIOSAlertView alloc] init];
    UIView *rootView;
    rootView = dialogview;
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
}
- (void) closeDialog{
    [alertView close];
}
- (void)flip
{
    _flipButton.enabled = NO;
    
    // 翻转
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.35;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    
    NSUInteger front = [_mainBgView.subviews indexOfObject:_frontView];
    NSUInteger back = [_mainBgView.subviews indexOfObject:_backView];
    [_mainBgView exchangeSubviewAtIndex:front withSubviewAtIndex:back];
    
    [_mainBgView.layer addAnimation:animation forKey:@"animation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _flipButton.enabled = YES;;
}

// 已收到
- (void)receiveCard
{
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized078", nil)];
            [weakself cardReceivedComplete];
        }
    }];
    [request confirmCard:_cardModel.postcard_id];
}

- (void)cardReceivedComplete
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadReceiveNotification" object:nil];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(kScreenWidth - 40 - 5, CGRectGetMaxY(_mainBgView.frame) + 5, 40, 40);
    [shareButton setImage:[UIImage imageNamed:@"public-share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:shareButton];
    
    [_handleButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [_handleButton addTarget:self action:@selector(handlePublic:) forControlEvents:UIControlEventTouchUpInside];
    [_handleButton setTitle:NSLocalizedString(@"localized059", nil) forState:UIControlStateNormal];
    [_handleButton setTitle:NSLocalizedString(@"localized060", nil) forState:UIControlStateSelected];
    _handleButton.selected = _cardModel.sharing_state == 1 ? NO : YES;
    [self handlePublicComplete:_handleButton];
}

// （取消）公开
- (void)handlePublic:(UIButton *)button
{
    __weak typeof(self) weakself = self;
    if (button.isSelected) { // 取消公开
        NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
        [request completion:^(id result, BOOL succ) {
            if (succ) {
                button.selected = !button.isSelected;
                [weakself handlePublicComplete:button];
            }
        }];
        [request cancelPublicCard:_cardModel.postcard_id];
    } else { // 公开
        NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
        [request completion:^(id result, BOOL succ) {
            if (succ) {
                button.selected = !button.isSelected;
                [weakself handlePublicComplete:button];
            }
        }];
        [request publicCard:_cardModel.postcard_id];
    }
}

- (void)handlePublicComplete:(UIButton *)button
{
    [Constants setPublicButtonColor:button.isSelected ? kRedColor : kGreenColor button:button];
}

// 分享
- (void)share:(UIButton *)button
{
    [ShareOperation shareInstance].viewController = self;
    [[ShareOperation shareInstance] showShareView:button imagePath:_cardModel.postcard_head image:_frontView.image complete:nil];
}

@end
