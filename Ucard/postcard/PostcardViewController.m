//
//  PostcardViewController.m
//  Ucard
//
//  Created by Conner Wu on 15-4-7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PostcardViewController.h"
#import "CardNewCoverView.h"
#import "CardNewFrontWrapView.h"
#import "CardNewBackView.h"
#import "FrontBgView.h"
#import "BackBgView.h"
#import "PayViewController.h"
#import "PostcardTextViewController.h"
#import "SignPopView.h"
#import "AppDelegate.h"
#import "GPUImageiOSBlurFilter.h"
#import "AddressPopView.h"
#import "PostcardCountryViewController.h"
#import "MBProgressHUD.h"
#import "UIImage+Resizing.h"
#import "CustomIOSAlertView.h"
#import "StampPopView.h"
#import "LocationViewController.h"
#import "TypeView.h"


@interface PostcardViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    CardNewCoverView *_coverView;
    CardNewFrontWrapView *_frontView;
    CardNewBackView *_backView;
    FrontBgView *_frontBgView;
    BackBgView *_backBgView;
    UIImageView *_bgImageView;
    UIButton *_flipButton;
    UIView *_mainBgView;
    SignPopView *_signPopView;
    AddressPopView *_addressPopView;
    StampPopView *_stampPopView;
    NetworkRequest *_uploadRequest;
    UIView *viewframe;
    UIView *viewtap;
    UIButton *_frameButton;
    UIView *viewtop;
    UIView *views;
    TypeView *_typeView;
    BOOL Checked;
    UILabel*label;
    UITextField *textfield;
}
@end

@implementation PostcardViewController
bool canClick;
int countryID;
int countryIndex = -1;
bool isBlack = TRUE;
CustomIOSAlertView *alertView;
UIScrollView *scrollView;
UIButton *blackButton, *blueButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavLogo];
    [self hideNavLogo];
    [self resetAllView];
    [self hideBackLogo];
    [views setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if ([Singleton shareInstance].cardModel.hasUploaded) {
        [self showPayViewController:NO];
    }
}
-(void) showBackLogo
{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
    super.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)goBack
{
    [self hideBackLogo];
    [self flip];
}
-(void) hideBackLogo{
    super.navigationItem.leftBarButtonItem = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetAllView
{
    [Singleton shareInstance].cardModel = [DraftCardModel select];
    // 清空所有view
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    self.title = @"Make UCard";
    // 背景图片
    _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.alpha = 0.3;
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0];
    // 正反面父视图
    CGFloat heightpost;
    CGFloat heightframe;
    CGFloat tapbutton;
    CGFloat widthbuttonframe;
    CGFloat heightbuttonframes;
    CGFloat widthtbuttonframes;
    CGFloat hightflipButton;
    CGFloat hmainBgView ;
    CGFloat hightflipButtons;
    CGFloat hblack;
    CGFloat hbutton;
    CGFloat hsubmitbn;
    CGFloat widths;
    CGFloat widthtf;
     int fontSmall;
    
    if(kR35) {
        heightpost = 100;
        heightframe = 40;
        tapbutton = 45;
        widthbuttonframe = 50;
        heightbuttonframes = 25;
        widthtbuttonframes = 80;
        hightflipButton = 75;
        hightflipButtons = 150;
        hmainBgView = 10;
        hblack = 15;
        hbutton = 25;
        hsubmitbn = 40;
        widths = 120;
        widthtf=220;
        fontSmall = 11;
    }
    else if(kR40){
        heightpost =50;
        widthtf= 180;
        heightframe =50;
        tapbutton =55;
        widthbuttonframe =80;
        heightbuttonframes =30;
        widthtbuttonframes =125;
        hightflipButton =110;
        hightflipButtons =150;
        hmainBgView =15;
        hblack =20;
        hbutton =10;
        hsubmitbn =60;
        widths =150;
        fontSmall =11;
    }
    else if(kR47) {
        heightpost = 50;
        heightframe = 50;
        tapbutton = 55;
        widthbuttonframe = 80;
        heightbuttonframes = 30;
        widthtbuttonframes = 125;
        hightflipButton = 110;
        hightflipButtons = 200;
        hmainBgView = 15;
        hblack = 20;
        hbutton = 25;
        hsubmitbn = 110;
        widths =  180;
        widthtf= 230;
        fontSmall =  14;

    }
    else if(kR55) {
       heightpost = 40;
       heightframe = 50;
       tapbutton = 55;
       widthbuttonframe = 80;
       heightbuttonframes = 30;
       widthtbuttonframes = 125;
       hightflipButton = 110;
       hightflipButtons = 250;
       hmainBgView = 15;
       hblack = 15;
       hbutton = 35;
       hsubmitbn = 150;
       widths = 200;
       widthtf= 270;
        fontSmall = 17;
    }

    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    int height = self.view.frame.size.height - 65;
    CGRect frame =self.view.frame;
    frame.size.height = height;
    scrollView.frame = frame;
    [self.view addSubview:scrollView];
    int imageWidth = kScreenWidth - hmainBgView * 2;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _mainBgView = [[UIView alloc] initWithFrame:CGRectMake(hmainBgView,5, imageWidth, kCardHeight * imageWidth / kCardWidth)];
    _mainBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    _mainBgView.layer.shadowOpacity = 0.7;
    _mainBgView.layer.shadowOffset = CGSizeMake(0, 0);
    _mainBgView.layer.shadowRadius = 2.0;
    [contentView addSubview:_mainBgView];
    _mainBgView.backgroundColor=[UIColor whiteColor];
    // 反面
    __weak typeof(self) weakself = self;
    _backView = [[CardNewBackView alloc] initWithFrame:_mainBgView.bounds];
    _backView.toolBlock = ^(NSUInteger index) {
        [weakself toolsMethod:index];
    };
    [_mainBgView addSubview:_backView];
    // 正面
    _frontView = [[CardNewFrontWrapView alloc] initWithFrame:_mainBgView.bounds];
    [_mainBgView addSubview:_frontView];
    viewtop =[[UIView alloc] initWithFrame:CGRectMake(hmainBgView,CGRectGetMaxY(_mainBgView.frame) + 10, kScreenWidth-hmainBgView*2, heightframe +  kCardHeight * kScreenWidth / kCardWidth )];
    viewframe= [[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth-hmainBgView*2,heightframe)];
    viewframe.backgroundColor=[UIColor whiteColor];
    
    label= [[UILabel alloc] initWithFrame:CGRectMake(10,0, widthtf,heightframe)];
    label.text=NSLocalizedString(@"localized224",nil);
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor grayColor];
    label.hidden = NO;
    [viewframe addSubview:label];

    textfield= [[UITextField alloc] initWithFrame:CGRectMake(10,10,widthtf,heightbuttonframes)];
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"localized236",nil) attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, textfield.frame.size.height)];
    [textfield setLeftViewMode:UITextFieldViewModeAlways];
    [textfield setLeftView:paddingView];
    [textfield setAlpha:1];
    textfield.layer.cornerRadius =  4;
    textfield.layer.borderColor = kGColor.CGColor;
    textfield.layer.borderWidth = 1;
    textfield.font=[UIFont systemFontOfSize:13];
    textfield.tag = 1000;
    textfield.textColor=kGColor;
    textfield.delegate = self;
    textfield.hidden = YES;
    [viewframe addSubview:textfield];
    
    // 边框
    _frameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _frameButton.frame = CGRectMake(kScreenWidth-widthtbuttonframes, 10, widthbuttonframe, heightbuttonframes);
    [_frameButton setImage:[UIImage imageNamed:@"framehide"] forState:UIControlStateNormal];
    [_frameButton setImage:[UIImage imageNamed:@"frameshow"] forState:UIControlStateSelected];
    _frameButton.selected = NO;
    [_frameButton addTarget:self action:@selector(handleFramePostCard:) forControlEvents:UIControlEventTouchUpInside];
    [viewframe addSubview:_frameButton];
    viewtap = [[UIView alloc] initWithFrame:CGRectMake(0,tapbutton, kScreenWidth-hmainBgView*2,kCardHeight * kScreenWidth / kCardWidth )];
    viewtap.backgroundColor=[UIColor whiteColor];
    
    
    // 正面背景
    __weak CardNewFrontWrapView *weakFrontView = _frontView;
    _frontBgView = [[FrontBgView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-hmainBgView*2, 100)];
    _frontBgView.refreshImageBlock = ^() {
        [weakFrontView setContent:NO];
    };
    [viewtap addSubview:_frontBgView];
    
    // next
    _flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flipButton.frame = CGRectMake((kScreenWidth-hightflipButton) / 2, hightflipButtons + (kR35 ? 0 : 0), widthbuttonframe, 30);
    [_flipButton addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
    _flipButton.layer.cornerRadius =  4;
//    _flipButton.layer.borderColor = [UIColor colorWithRed:0.9020 green:0.9020 blue:0.9020 alpha:1.0000].CGColor;
//    _flipButton.layer.borderWidth = 1;
    _flipButton.backgroundColor=kGColor;
    [_flipButton setTitle:NSLocalizedString(@"localized225",nil) forState:UIControlStateNormal];
    _flipButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [viewtap addSubview:_flipButton];
    // 反面背景
    _backBgView = [[BackBgView alloc] initWithFrame:_frontBgView.frame];
    _backBgView.toolBlock = ^(NSUInteger index) {
        [weakself toolsMethod:index];
    };
    _backBgView.alpha = 0;
    [viewtap insertSubview:_backBgView belowSubview:_frontBgView];
    
    [contentView addSubview:viewtop];
    [viewtop addSubview:viewtap];
    [viewtop addSubview:viewframe];
    
    
    views=[[UIView alloc] initWithFrame:CGRectMake(hmainBgView,CGRectGetMaxY(_mainBgView.frame) + 10, kScreenWidth-hmainBgView*2,kScreenHeight)];
    CGRect viewFrame = viewtop.frame;
    views.frame = viewFrame;
    views.backgroundColor=[UIColor clearColor];
    
    
    UIView *view1= [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth-hmainBgView*2,heightframe)];
    UILabel *label1= [[UILabel alloc] initWithFrame:CGRectMake(10,0,CGRectGetWidth(view1.frame) - 10 * 2 - 65 * 2 - 30 - 10,heightframe)];
    label1.text=NSLocalizedString(@"localized226",nil);
    label1.font=[UIFont systemFontOfSize:fontSmall];
    label1.textColor=[UIColor grayColor];
    view1.backgroundColor=[UIColor whiteColor];
    
    int buttonSize = 10;
    int textSize = 15;
    if (kR55) {
        buttonSize = 20;
        textSize = 18;
    }
    
    
    blackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    blackButton.frame = CGRectMake(CGRectGetMaxX(label1.frame) + 30,hblack,buttonSize,buttonSize);
    [blackButton setImage:[UIImage imageNamed:@"select_off"] forState:UIControlStateNormal];
    [blackButton setImage:[UIImage imageNamed:@"select_on"] forState:UIControlStateSelected];
    blackButton.selected = YES;
    [blackButton addTarget:self action:@selector(changeToBlack) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *blacklb= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(blackButton.frame) + 5,0,50,heightframe)];
    blacklb.text=NSLocalizedString(@"localized227",nil);
    blacklb.font=[UIFont systemFontOfSize:textSize];
    blacklb.textColor=kGColor;
    [view1 addSubview:blacklb];
    
    
    blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    blueButton.frame = CGRectMake(CGRectGetMaxX(blacklb.frame) + 10 ,hblack, buttonSize, buttonSize);
    [blueButton setImage:[UIImage imageNamed:@"select_off"] forState:UIControlStateNormal];
    [blueButton setImage:[UIImage imageNamed:@"select_on"] forState:UIControlStateSelected];
    blueButton.selected = NO;
    [blueButton addTarget:self action:@selector(changeToBlue) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *bluelb= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(blueButton.frame)+ 5,0,50,heightframe)];
    bluelb.text=NSLocalizedString(@"localized228",nil);
    bluelb.font=[UIFont systemFontOfSize:textSize];
    bluelb.textColor=kGColor;
    
    [view1 addSubview:bluelb];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(view1.frame), kScreenWidth-hmainBgView*2, views.frame.size.height - CGRectGetMaxY(view1.frame))];
    CGRect a = views.frame;
    a = view1.frame;
    a = view2.frame;
    view2.backgroundColor=[UIColor clearColor];
    
    
    UIView *view3=[[UIView alloc] initWithFrame:CGRectMake(0,5,CGRectGetMaxX(view2.frame),widths)];
    view3.backgroundColor=[UIColor whiteColor];
    CGRect b;
    int margin = (view3.frame.size.width - (heightframe + 10) * 4 - 2 * hbutton) / 3;
    
    UIButton *greetingbt = [UIButton buttonWithType:UIButtonTypeCustom];
    greetingbt.frame = CGRectMake(hbutton,10, heightframe+10, heightframe+10);
    [greetingbt setImage:[UIImage imageNamed:@"greeting"] forState:UIControlStateNormal];
    b = greetingbt.frame;
    [greetingbt addTarget:self action:@selector(showTextViewController) forControlEvents:UIControlEventTouchUpInside];
    UILabel *greetinglb= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(greetingbt.frame) - 40,CGRectGetMaxY(greetingbt.frame)+2,80,20)];
    greetinglb.text=NSLocalizedString(@"localized229",nil);
    greetinglb.textAlignment = NSTextAlignmentCenter;
    greetinglb.font=[UIFont systemFontOfSize:13];
    greetinglb.textColor=kGColor;
    [view3 addSubview:greetinglb];
    
    UIButton *signaturebt = [UIButton buttonWithType:UIButtonTypeCustom];
    signaturebt.frame = CGRectMake(CGRectGetMaxX(greetingbt.frame) + margin, 10, heightframe+10, heightframe+10);
    [signaturebt setImage:[UIImage imageNamed:@"signature"] forState:UIControlStateNormal];
    [signaturebt addTarget:self action:@selector(showSignPopView) forControlEvents:UIControlEventTouchUpInside];
    UILabel *signaturelb= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(signaturebt.frame) - 40,CGRectGetMaxY(greetingbt.frame)+2,80,20)];
    signaturelb.text=NSLocalizedString(@"localized230",nil);
    signaturelb.textAlignment = NSTextAlignmentCenter;
    signaturelb.font=[UIFont systemFontOfSize:13];
    signaturelb.textColor=kGColor;
    
    b = signaturebt.frame;
    [view3 addSubview:signaturelb];
    
    
    UIButton *addressbt = [UIButton buttonWithType:UIButtonTypeCustom];
    addressbt.frame = CGRectMake(CGRectGetMaxX(signaturebt.frame) + margin,10,  heightframe+10, heightframe+10);
    [addressbt setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
    [addressbt addTarget:self action:@selector(showAddressPopView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addresslb= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(addressbt.frame) - 40,CGRectGetMaxY(addressbt.frame)+2,80,20)];
    addresslb.text=NSLocalizedString(@"localized231",nil);
    addresslb.textAlignment = NSTextAlignmentCenter;
    addresslb.font=[UIFont systemFontOfSize:13];
    addresslb.textColor=kGColor;
    
    b = addressbt.frame;
    [view3 addSubview:addresslb];
    
    
    UIButton *stampbt = [UIButton buttonWithType:UIButtonTypeCustom];
    stampbt.frame = CGRectMake(CGRectGetMaxX(addressbt.frame) + margin,10,heightframe+10, heightframe+10);
    [stampbt setImage:[UIImage imageNamed:@"rain"] forState:UIControlStateNormal];
    [stampbt addTarget:self action:@selector(showStampPopView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *stamplb= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(stampbt.frame) - 40,CGRectGetMaxY(greetingbt.frame)+2,80,20)];
    stamplb.text=NSLocalizedString(@"localized232",nil);
    stamplb.font=[UIFont systemFontOfSize:13];
    stamplb.textAlignment = NSTextAlignmentCenter;
    stamplb.textColor=kGColor;
    
    b = stampbt.frame;
    [view3 addSubview:stamplb];
    
    
    
    UIButton *submitbn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitbn addTarget:self
                 action:@selector(navNext)forControlEvents:UIControlEventTouchUpInside];
    [submitbn setTitle:NSLocalizedString(@"localized022",nil) forState:UIControlStateNormal];
    
    submitbn.frame =CGRectMake(10, CGRectGetMaxY(view3.frame) +  20 ,kScreenWidth-hmainBgView*2 -20, 40);
    a = submitbn.frame;
    submitbn.backgroundColor=kGColor;
    submitbn.layer.cornerRadius =  4;
    submitbn.layer.borderColor = [UIColor colorWithRed:0.9020 green:0.9020 blue:0.9020 alpha:1.0000].CGColor;
    submitbn.layer.borderWidth = 1;
    submitbn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    a = view2.frame;
    a.size.height = view3.frame.size.height + 5 + 20 + 40 + 20;
    view2.frame = a;
    a = views.frame;
    a.size.height = view1.frame.size.height + view2.frame.size.height;
    views.frame = a;
    [view2 addSubview:submitbn];
    [view3 addSubview:greetingbt];
    [view3 addSubview:signaturebt];
    [view3 addSubview:addressbt];
    [view3 addSubview:stampbt];
    [view2 addSubview:view3];
    [view1 addSubview:blackButton];
    [view1 addSubview:blueButton];
    [view1 addSubview:label1];
    [views addSubview:view2];
    [views addSubview:view1];
    [contentView addSubview:views];
    CGRect frm = viewtop.frame;
    frm = contentView.frame;
    frm.size.width = kScreenWidth;
    frm.size.height = CGRectGetMaxY(viewtop.frame) + 10;
    contentView.frame = frm;
    [scrollView addSubview:contentView];
    scrollView.contentSize = contentView.frame.size;
    
    
    // 添加图片按钮视图
    _coverView = [[CardNewCoverView alloc] initWithFrame:_mainBgView.frame];
    a = _coverView.frame;
    a.origin.x = 0;
    a.origin.y = 0;
    _coverView.frame = a;
    _coverView.showAlbumBlock = ^() {
        [weakself showAlbum];
    };
    [_mainBgView addSubview:_coverView];
    
    if ([[Singleton shareInstance].cardModel cachePhoto]) {
        canClick = TRUE;
        [self handleSelectedPhoto];
        
    } else canClick = FALSE;
}
- (void)handleFramePostCard:(UIButton *)button
{
    if (!canClick) {
        return;
    }
    if (!button.selected) {
        textfield.hidden = NO;
        label.hidden = YES;
    } else {
        [textfield resignFirstResponder];
        textfield.hidden =YES;
        label.hidden = NO;
    }
    [_frontBgView handleFrame:button];
    
}
#pragma mark 显示左边和右边按钮
- (void)hidesNavPhotoButton
{
    self.navigationItem.leftBarButtonItem = nil;
}
- (void)showNavNextButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"localized129", nil) style:UIBarButtonItemStylePlain target:self action:@selector(navNext)];
    self.navigationItem.rightBarButtonItem.tintColor = kGreenColor;
}
- (void)showBack
{
    [self flip];
}
- (void)navNext
{
    NSString *tips;
    if (![Singleton shareInstance].cardModel.photoImage) {
        tips = NSLocalizedString(@"localized187", nil);
    } else if (![Singleton shareInstance].cardModel.text || [Singleton shareInstance].cardModel.text.length == 0) {
        tips = NSLocalizedString(@"localized188", nil);
    } else if (![Singleton shareInstance].cardModel.signImage) {
        tips = NSLocalizedString(@"localized189", nil);
    } else if (![Singleton shareInstance].cardModel.country || [Singleton shareInstance].cardModel.country.length == 0) {
        tips = NSLocalizedString(@"localized190", nil);
    } else if (countryIndex == -1) {
        tips = @"Please choose stamps.";
    }
    
    if (tips) {
        [Constants showTipsMessage:tips];
        return;
    }
    
    [self submitCard];
}

#pragma mark 图片

- (void)showAlbum
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"localized073", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"localized074", nil), NSLocalizedString(@"localized075", nil), nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        
        switch (buttonIndex) {
            case 0: {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
                break;
            }
                
            case 1: {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                break;
            }
                
            default:
                break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
        editor.delegate = self;
        [self presentViewController:editor animated:YES completion:nil];
    }];
}

// 选择图片
- (void)photoSelected:(UIImage *)image
{
    // 保存数据
    [Singleton shareInstance].cardModel.photoImage = image;
    if ([Singleton shareInstance].cardModel.cardId) {
        [Singleton shareInstance].cardModel.brightness = 1;
        [Singleton shareInstance].cardModel.saturate = 1;
        [Singleton shareInstance].cardModel.contrast = 1;
        [Singleton shareInstance].cardModel.frame = NO;
        [[Singleton shareInstance].cardModel savePhoto];
        [[Singleton shareInstance].cardModel updateData];
    } else {
        [[Singleton shareInstance].cardModel insert];
        [Singleton shareInstance].cardModel = [DraftCardModel select];
        
        // 获取明信片ID
        NetworkRequest *request = [[NetworkRequest alloc] init];
        [request completion:^(id result, BOOL succ) {
            if (succ) {
                [Singleton shareInstance].cardModel.remoteCardId = [result objectForKey:@"data"];
                [[Singleton shareInstance].cardModel updateData];
            }
        }];
        [request getCardId];
    }
    
    [_frontView resetScrollView];
    [self handleSelectedPhoto];
}

- (void)handleSelectedPhoto
{
    // 关闭添加图片view
    [UIView animateWithDuration:0.35
                     animations:^{
                         _coverView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [_coverView setTranparent];
                         canClick = TRUE;
                     }];
    
    // 背景
    [self performSelectorInBackground:@selector(handleBg) withObject:nil];
    
    // 填充各面板数据
    _frameButton.selected = [Singleton shareInstance].cardModel.frame;
    if (_frameButton.selected) {
        textfield.hidden = NO;
        label.hidden = YES;
    } else {
        textfield.hidden =YES;
        label.hidden = NO;
    }
    textfield.text = [Singleton shareInstance].cardModel.captionText;
    bool isBlack = ([Singleton shareInstance].cardModel.color == 0);
    blackButton.selected = isBlack;
    blueButton.selected = !isBlack;
    countryIndex = (int) [Singleton shareInstance].cardModel.stamp;
    [_frontView setContent:YES];
    [_frontBgView setContent];
    [_backView setContent : isBlack];
    [_backBgView setContent];
    
}

// 毛玻璃背景
- (void)handleBg
{
    GPUImageiOSBlurFilter *filter = [[GPUImageiOSBlurFilter alloc] init];
    filter.blurRadiusInPixels = 12;
    UIImage *image = [filter imageByFilteringImage:[Singleton shareInstance].cardModel.photoImage];
    [[Singleton shareInstance].cardModel saveBgImage:image];
    
    [self performSelectorOnMainThread:@selector(showBg) withObject:nil waitUntilDone:YES];
}

- (void)showBg
{
    _bgImageView.image = [[Singleton shareInstance].cardModel getBgImage];
    _bgImageView.alpha = 0.0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         _bgImageView.alpha = 0.3;
                     }];
}

#pragma mark 切换正反面

- (void)flip
{
    if (!canClick) {
        return;
    }
    if (self.navigationItem.leftBarButtonItem) {
        [self hideBackLogo];
    } else {
        [self showBackLogo];
    }
    if (_flipButton.isSelected) {
        [self hideBackLogo];
        CGSize frm = scrollView.contentSize;
        frm.height = CGRectGetMaxY(viewtop.frame) + 10;
        scrollView.contentSize = frm;
    } else {
        [self hidesNavPhotoButton];
        [self hideNavLogo];
        _coverView.alpha = 0;
        CGSize frm = scrollView.contentSize;
        frm.height = CGRectGetMaxY(views.frame) + 10;
        scrollView.contentSize = frm;
        // 正面画图
        [_frontView performSelectorInBackground:@selector(clipImageView) withObject:nil];
    }

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
    
    //     工具背景视图
    [UIView animateWithDuration:animation.duration
                     animations:^{
                         if (_flipButton.isSelected) {
                             _frontBgView.alpha = 1;
                             _backBgView.alpha = 0;
                             [views setHidden:YES];
                             [viewtop setHidden:NO];
                         } else {
                             _frontBgView.alpha = 0;
                             _backBgView.alpha = 1;
                             [viewtop setHidden:YES];
                             [views setHidden:NO];
                         }
                     } completion:^(BOOL finished) {
                         _flipButton.selected = !_flipButton.isSelected;
                         _flipButton.enabled = YES;
                     }];
}

#pragma mark 背面

- (void)toolsMethod:(NSUInteger)index
{
    switch (index) {
        case 0:
            [self showTextViewController];
            break;
            
        case 1:
            [self showSignPopView];
            break;
            
        case 2:
            [self showAddressPopView];
            break;
            
        case 3:
            [self showLocationViewController];
            break;
        case 4:
            [self showStampPopView];
            
        default:
            break;
    }
}

- (void)showLocationViewController
{
    LocationViewController *viewController = [[LocationViewController alloc] init];
    viewController.updateLocation = ^() {
        [_backView setContent];
        [_backBgView setContent];
    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
}
// 显示文本
- (void)showTextViewController
{
    PostcardTextViewController *viewController = [[PostcardTextViewController alloc] init];
    [viewController setTextContentFrame: [_backView getTextContentFrame]];
    viewController.updateTextBlock = ^() {
        [_backView setContent];
        [_backBgView setContent];
    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
}
// 签名
- (void)showSignPopView
{
    UIView *superView = [AppDelegate shareDelegate].window.rootViewController.view;
    CGRect frame = CGRectMake(-(kScreenHeight - kScreenWidth) / 2, (kScreenHeight - kScreenWidth) / 2, CGRectGetHeight(superView.bounds), CGRectGetWidth(superView.bounds));
    
    __weak typeof(self) weakself = self;
    CGFloat height = kScreenWidth - 5 * 2;
    CGFloat width = (height - 44 * 2) / (kSignWH);
    _signPopView = [[SignPopView alloc] initWithFrame:frame bgFrame:CGRectMake((CGRectGetWidth(frame) - width) / 2, (CGRectGetHeight(frame) - height) / 2, width, height) title:NSLocalizedString(@"localized130", nil)];
    _signPopView.alpha = 0.0;
    _signPopView.transform = CGAffineTransformMakeRotation(90.0 * M_PI/180.0);
    [_signPopView hideCancel];
    _signPopView.closeBlock = ^(BOOL done) {
        [weakself closeSignPopView];
        if (done) {
            [weakself showSign];
        }
    };
    [superView addSubview:_signPopView];
    
    superView.userInteractionEnabled = NO;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         _signPopView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         superView.userInteractionEnabled = YES;
                     }];
    
}

- (void)closeSignPopView
{
    _signPopView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.35
                     animations:^{
                         _signPopView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [_signPopView removeFromSuperview];
                         _signPopView = nil;
                     }];
}

- (void)showSign
{
    [_backView setContent];
    [_backBgView setContent];
}

// 地址
- (void)showAddressPopView
{
    UIView *superView = [AppDelegate shareDelegate].window.rootViewController.view;
    CGRect frame = superView.bounds;
    
    __weak typeof(self) weakself = self;
    CGFloat width = kPopWidth;
    CGFloat height = kScreenHeight - 70 * 2;
    _addressPopView = [[AddressPopView alloc] initWithFrame:frame bgFrame:CGRectMake((CGRectGetWidth(superView.frame) - width) / 2, (CGRectGetHeight(frame) - height) / 2, width, height) title:NSLocalizedString(@"localized131", nil)];
    _addressPopView.alpha = 0.0;
    _addressPopView.closeBlock = ^(BOOL done) {
        [weakself closeAddressPopView];
        if (done) {
            [weakself showAddress];
        }
    };
    _addressPopView.showCountryBlock = ^() {
        [weakself showCountry];
    };
    
    [_addressPopView adjustButton];
    [_addressPopView showCancel];
    [superView addSubview:_addressPopView];
    
    superView.userInteractionEnabled = NO;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         _addressPopView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         superView.userInteractionEnabled = YES;
                     }];
    
}

- (void)closeAddressPopView
{
    _addressPopView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.35
                     animations:^{
                         _addressPopView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [_addressPopView removeFromSuperview];
                         _addressPopView = nil;
                     }];
}

- (void)showStampPopView {
    UIView *superView = [AppDelegate shareDelegate].window.rootViewController.view;
    CGRect frame = superView.bounds;
    
    __weak typeof(self) weakself = self;
    CGFloat width = kPopWidth;
    CGFloat height = kScreenHeight - 70 * 2;
    _stampPopView = [[StampPopView alloc] initWithFrame:frame bgFrame:CGRectMake((CGRectGetWidth(superView.frame) - width) / 2, (CGRectGetHeight(frame) - height) / 2, width, height) title:NSLocalizedString(@"Choose Stamp\n(where it sent from)", nil)];
    _stampPopView.alpha = 0.0;
    _stampPopView.closeBlock = ^(BOOL done) {
        [weakself closeStamp];
        if (done) {
            countryIndex = countryID;
            [Singleton shareInstance].cardModel.hasUploaded = NO;
            [Singleton shareInstance].cardModel.stamp = countryIndex;
            [[Singleton shareInstance].cardModel updateData];
        }
    };
    _stampPopView.chooseIceland = ^ (){
        
        countryID = 1;
    };
    _stampPopView.chooseChina = ^ (){
        countryID = 0;
    };
    [_stampPopView showCancel];
    [_stampPopView adjustButtonStamp];
    [superView addSubview:_stampPopView];
    
    superView.userInteractionEnabled = NO;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         _stampPopView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         superView.userInteractionEnabled = YES;
                     }];
}
- (void)closeStamp
{
    _stampPopView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.35
                     animations:^{
                         _stampPopView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [_stampPopView removeFromSuperview];
                         _stampPopView = nil;
                     }];
}
- (void)showAddress
{
    [_backView setContent];
    [_backBgView setContent];
}
- (void)showCountry
{
    PostcardCountryViewController *viewController = [[PostcardCountryViewController alloc] init];
    viewController.countryBlock = ^(CountryModel *country) {
        [_addressPopView setCountryModel:country];
    };
    viewController.onlyEnglish = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void) changeToBlack{
    
    if (blackButton.selected) {
        return;
    }
    blackButton.selected = YES;
    blueButton.selected = NO;
    [self changeColor:YES];
    
}
-(void) changeToBlue {
    if (blueButton.selected) {
        return;
    }
    blueButton.selected = YES;
    blackButton.selected = NO;
    [self changeColor:NO];
}
-(void) changeColor: (BOOL *) isBlack {
    [Singleton shareInstance].cardModel.hasUploaded = NO;
    if (isBlack) {
        [Singleton shareInstance].cardModel.color = 0;
    } else {
        
        [Singleton shareInstance].cardModel.color = 1;
    }
    
    [[Singleton shareInstance].cardModel updateData];
    [_backView setContent:isBlack];
}
// 提交明信片
- (void)submitCard
{
    [[Singleton shareInstance] startLoading];
    
    [self performSelector:@selector(submitCardDelay) withObject:nil afterDelay:2.0];
}

- (void)submitCardDelay
{
    
    if (![Singleton shareInstance].cardModel.hasUploaded) {
        __weak typeof(self) weakself = self;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 120)];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake((CGRectGetWidth(containerView.frame) - CGRectGetWidth(indicatorView.frame)) / 2.0f, 25, CGRectGetWidth(indicatorView.frame), CGRectGetHeight(indicatorView.frame));
        [indicatorView startAnimating];
        [containerView addSubview:indicatorView];
        
        UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(indicatorView.frame) + 20, CGRectGetWidth(containerView.frame), 20)];
        percentLabel.font = [UIFont systemFontOfSize:15];
        percentLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:percentLabel];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(30, CGRectGetMaxY(percentLabel.frame) + 10, CGRectGetWidth(containerView.frame) - 30 * 2, CGRectGetHeight(progressView.frame));
        [containerView addSubview:progressView];
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        [alertView setContainerView:containerView];
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:NSLocalizedString(@"localized073", nil), nil]];
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            [weakself cancelUpload];
            [alertView close];
        }];
        [alertView setUseMotionEffects:YES];
        [alertView show];
        
        _uploadRequest = [[NetworkRequest alloc] init];
        [_uploadRequest uploadProgress:^(float progress) {
            [progressView setProgress:progress animated:YES];
            percentLabel.text = [NSString stringWithFormat:@"%0.0f%%", progress * 100.0];
        }];
        [_uploadRequest completion:^(id result, BOOL succ) {
            [alertView close];
            if (succ) {
                [Singleton shareInstance].cardModel.hasUploaded = YES;
                [[Singleton shareInstance].cardModel updateData];
                
                [weakself showPayViewController];
            }
            _uploadRequest = nil;
        }];
        [_uploadRequest updateCard];
    } else {
        [self showPayViewController];
    }
    
    [[Singleton shareInstance] stopLoading];
}

- (void)cancelUpload
{
    [_uploadRequest cancelOperation];
}

- (void)showPayViewController
{
    [self showPayViewController:YES];
}

- (void)showPayViewController:(BOOL)animated
{
    PayViewController *viewController = [[PayViewController alloc] init];
    viewController.countryID = countryIndex;
    [self.navigationController pushViewController:viewController animated:animated];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    image = [self fixOrientation:image];
    if (kR35) {
        CGSize newSize;
        CGSize size = kR35 ? CGSizeMake(700, 500) : CGSizeMake(2000, 1500);
        int h = image.size.height;
        int w = image.size.width;
        if (h <= size.height && w <= size.width) {
            newSize = image.size;
        } else {
            float destWith = 0.0f;
            float destHeight = 0.0f;
            
            float suoFang = (float)w/h;
            float suo = (float)h/w;
            if (w > h) {
                destWith = (float)size.width;
                destHeight = size.width * suo;
            } else {
                destHeight = (float)size.height;
                destWith = size.height * suoFang;
            }
            
            newSize = CGSizeMake(destWith, destHeight);
        }
        
        image = [image scaleToSize:newSize];
    }
    
    [self photoSelected:image];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDraftNotification" object:nil];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
}
- (void)imageEditorDidCancel:(CLImageEditor*)editor
{
    [editor dismissViewControllerAnimated:YES completion:nil];
}




- (void)showCaptionPopView
{
    if(!_frameButton.selected) return;
    UIView *superView = [AppDelegate shareDelegate].window.rootViewController.view;
    CGRect frame = superView.bounds;
    
    __weak typeof(self) weakself = self;
    CGFloat width = kPopWidth;
    CGFloat height =200;
    _typeView = [[TypeView alloc] initWithFrame:frame bgFrame:CGRectMake((CGRectGetWidth(superView.frame) - width) / 2, (CGRectGetHeight(frame) - height) / 2, width, height) title:NSLocalizedString(@"Text Detail", nil)];
    _typeView.alpha = 0.0;
    _typeView.closeBlock = ^(BOOL done) {
        [weakself closeCaptionPopView];
        if (done) {
            [weakself showCaption];
        }
    };
    [_typeView adjustButton];
    [superView addSubview:_typeView];
    
    superView.userInteractionEnabled = NO;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         _typeView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         superView.userInteractionEnabled = YES;
                     }];
    
}

- (void)closeCaptionPopView
{
    _typeView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.35
                     animations:^{
                         _typeView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [_typeView removeFromSuperview];
                         _typeView = nil;
                     }];
}

-(void) showCaption {

}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    if (_textField.tag == 1000) {
        [Singleton shareInstance].cardModel.captionText = _textField.text;
        [Singleton shareInstance].cardModel.hasUploaded = NO;
        [[Singleton shareInstance].cardModel updateData];
        [_frontView setContent:NO];
        [_textField resignFirstResponder];
        
    }
    return YES;
}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
        
    }
    
    int yKB = screenSize.height - keyboardSize.height;
    int y0 = CGRectGetMaxY(viewframe.frame) + CGRectGetMinY(viewtop.frame) + self.navigationController.navigationBar.frame.size.height - scrollView.contentOffset.y;
    if (y0 > yKB - 5) {
        y0 = yKB - 5;
        int newOffsetY = CGRectGetMaxY(viewframe.frame) + CGRectGetMinY(viewtop.frame) + self.navigationController.navigationBar.frame.size.height - y0;
        CGRect frame = CGRectMake(0, newOffsetY, scrollView.frame.size.width, scrollView.frame.size.height); //wherever you want to scroll
        [scrollView scrollRectToVisible:frame animated:YES];
    }

}

- (void)keyboardWillHide: (NSNotification *)notification
{
}
@end
