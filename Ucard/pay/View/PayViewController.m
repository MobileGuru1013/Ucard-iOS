//
//  PayViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/4/11.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "PayViewController.h"
#import "PayTableViewCell.h"
#import "SVProgressHUD.h"
#import "NSUserDefaults+Helpers.h"
#import "PaySuccViewController.h"
#import "PriceModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "AlipayOrderModel.h"
#import "PaypalViewController.h"
#import "PayMillViewController.h"
#import "PayFooterView.h"
#import "PayPaypalFooterView.h"
#import "NSMutableAttributedString+Expanded.h"
#import "CustomIOSAlertView.h"


@interface PayViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    NSInteger _countryIndex;
    NSInteger _payIndex;
    NSInteger _pIndex;
    NSString *_orderId;
    NSString *_productName;
    NSString *_swiftId;
    PayModel *_payModel;
    PayPaypalFooterView *_paypalFooterView;
    UIImageView *viewimage;
    UIView * view1 ;
     UIView * view2 ;
     UIView * view3 ;
 
}
@end

@implementation PayViewController
int heightView1;
int heightView2;
int marginTop;
int marginInbox;
int fontSmall;
int fontDouble;
int fontSpec;
UILabel *priceLb;
UITextField *codeTxt;
bool isStartPay;
CustomIOSAlertView *alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self showNavLogo];
    [self hideNavLogo];
    isStartPay = FALSE;
    _countryIndex = self.countryID;
    _payIndex = 0;
    
    _dataArray = @[@{@"title": NSLocalizedString(@"localized033", nil), @"list": @[@{@"icon": @"pay-country-ie", @"text": NSLocalizedString(@"localized034", nil), @"id": @"IE"}, @{@"icon": @"pay-country-cn", @"text": NSLocalizedString(@"localized036", nil), @"id": @"CN"}, @{@"icon": @"placeholder", @"text": NSLocalizedString(@"localized035", nil), @"id": @"GB"}]},
                   @{@"title": NSLocalizedString(@"localized037", nil),
                     @"list": @[@{@"icon": @"pay-alipay", @"text": NSLocalizedString(@"localized038", nil), @"method": @"alipay"},
                                @{@"icon": @"pay-country-paypal", @"text": @"PayPal", @"method": @"paymill"}]}];
    
    marginTop = 5;
    [self initView];
    [self getPrice];
}

-(void) displayPrice {
    if (_payModel) {
        NSMutableString *text = [NSMutableString stringWithString:NSLocalizedString(@"", nil)];
        
        [text appendFormat:@" %@", _payModel.unit];
        [text appendFormat:@"%0.2f", _payModel.showPrice];
        priceLb.text = text;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:priceLb.text];
        [string setFontForText: _payModel.unit andSize:fontSpec];
        priceLb.attributedText = string;
    }
}

-(void) activeAlipay{
    int payIndex = 0;
    isStartPay = TRUE;
    if(payIndex == _payIndex){
        [self startPay];
    } else {
        _payIndex = payIndex;
        [self getPrice];
    }
}
-(void) activePaypal{
    int payIndex = 1;
    isStartPay = TRUE;
    if(payIndex == _payIndex){
        [self startPay];
    } else {
        _payIndex = payIndex;
        [self getPrice];
    }
}
-(void) activeWechat{
    int payIndex = 2;
    isStartPay = TRUE;
    if(payIndex == _payIndex){
        [self startPay];
    } else {
        _payIndex = payIndex;
        [self getPrice];
    }
}
-(void)aMethod : (BOOL) isSuccess;
{
    alertView = [[CustomIOSAlertView alloc] init];
    UIView *rootView;
    if (!isSuccess) {
        rootView = [self createFailDialogView];
    } else {
        rootView = [self createDialogView];
    }
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

- (void) initView{
    
    CGRect a;
    a = self.view.frame;
    heightView1 = (self.view.frame.size.height - marginTop * 4 - 120) / 4;
    
    CGFloat height;
    if(kR35) height =70;
    else if(kR40) height = 70;
    else if(kR47) height = 80;
    else if(kR55) height = 100;
    CGFloat height2;
    if(kR35){
        
        fontSmall = 13;
        fontDouble = 22;
        fontSpec = 15;
        height2 = 15;
    }
    else if(kR40){
        fontSmall = 15;
        fontDouble = 25;
        fontSpec = 20;
        height2 = 17;
    }
    else if(kR47){
        fontSmall = 16;
        fontDouble = 30;
        fontSpec = 25;
        height2 = 25;
    }
    else if(kR55){
        fontSmall = 17;
        fontDouble = 40;
        fontSpec = 30;
        height2 = 30;
    }
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:238/255.0 blue:235/255.0 alpha:1.0];
    view1 = [[UIView alloc] initWithFrame:CGRectMake(10,marginTop, kScreenWidth-20, heightView1)];
    a = view1.frame;
    view1.backgroundColor=[UIColor whiteColor];
    marginInbox = (heightView1 - height2 * 3) / 2;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, marginInbox, kScreenWidth-20, height2)];
    label.text= NSLocalizedString(@"localized212",nil);
    label.textColor =[UIColor grayColor];
    label.font = [UIFont systemFontOfSize:fontSmall];
    label.textAlignment = NSTextAlignmentCenter;
    priceLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + marginTop, kScreenWidth-20 ,height2 * 2)];
    priceLb.textColor =kGColor;
    priceLb.font = [UIFont systemFontOfSize:fontDouble];
    priceLb.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:label];
    [view1 addSubview:priceLb];
    marginInbox = (heightView1 - height2 * 3 - marginTop * 3) / 2;
    view2 = [[UIView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(view1.frame) + marginTop, kScreenWidth-20,heightView1)];
    a = view2.frame;
    view2.backgroundColor=[UIColor whiteColor];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, marginInbox, kScreenWidth-20, height2 * 1.5)];
    label3.text= NSLocalizedString(@"localized213",nil);
    label3.textColor =[UIColor grayColor];
    label3.font = [UIFont systemFontOfSize:fontSmall + 3];
    label3.textAlignment = NSTextAlignmentCenter;
    
    codeTxt = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label3.frame) + marginTop, kScreenWidth-60 ,height2 * 1.5)];
    codeTxt.placeholder=NSLocalizedString( @"localized214",nil);
    codeTxt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    codeTxt.layer.borderWidth = 1;
    codeTxt.backgroundColor =[UIColor whiteColor];
    codeTxt.textColor =[UIColor lightGrayColor];
    codeTxt.font = [UIFont systemFontOfSize:fontSmall + 3];
    codeTxt.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:label3];
    [view2 addSubview:codeTxt];
    
    view3 = [[UIView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(view2.frame) + marginTop, kScreenWidth-20,heightView1 * 2)];
    view3.backgroundColor=[UIColor yellowColor];
    a = view3.frame;
    
    view3.backgroundColor=[UIColor whiteColor];
    int heightButton = (view3.frame.size.height - 2 * marginTop) / 5;
    UIButton *aliPayBtt = [UIButton buttonWithType:
                           UIButtonTypeRoundedRect];
    [aliPayBtt setFrame:CGRectMake(30, heightButton, kScreenWidth-80, heightButton)];
    [aliPayBtt setTitle:NSLocalizedString(@"localized038",nil) forState:
     UIControlStateNormal];
    
    aliPayBtt.titleLabel.font = [UIFont systemFontOfSize:fontSmall];
    aliPayBtt.backgroundColor=kGColor;
    [aliPayBtt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    aliPayBtt.layer.cornerRadius =  4;
    aliPayBtt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    aliPayBtt.layer.borderWidth = 1;
 
    UIButton *paypalButton = [UIButton buttonWithType:
                              UIButtonTypeRoundedRect];
    [paypalButton setFrame:CGRectMake(30, CGRectGetMaxY(aliPayBtt.frame) + marginTop, kScreenWidth-80, heightButton)];
    [paypalButton setTitle:NSLocalizedString(@"localized215",nil) forState:UIControlStateNormal];
    paypalButton.titleLabel.font = [UIFont systemFontOfSize:fontSmall];
    paypalButton.backgroundColor=kGColor;
    [paypalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    paypalButton.layer.cornerRadius =  4;
    paypalButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    paypalButton.layer.borderWidth = 1;
    UIButton * wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [wechatButton setFrame:CGRectMake(30, CGRectGetMaxY(paypalButton.frame) + marginTop, kScreenWidth-80, heightButton)];
    [wechatButton setTitle:NSLocalizedString(@"localized216",nil) forState:UIControlStateNormal];
    wechatButton.font = [UIFont systemFontOfSize:fontSmall];
    wechatButton.backgroundColor=kGColor;
    [wechatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wechatButton.layer.cornerRadius = 4;
    wechatButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    wechatButton.layer.borderWidth = 1;
    [aliPayBtt addTarget:self action:@selector(activeAlipay) forControlEvents:UIControlEventTouchUpInside];
    [paypalButton addTarget:self action:@selector(activePaypal) forControlEvents:UIControlEventTouchUpInside];
    [wechatButton addTarget:self action:@selector(activeWechat) forControlEvents:UIControlEventTouchUpInside];
    
    [view3 addSubview:aliPayBtt];
    [view3 addSubview:paypalButton];
    [view3 addSubview:wechatButton];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
}
- (UIView *) createDialogView{
    
    CGFloat width1 = 110;
    if(kR35) width1 = 110;
    else if(kR40) width1 = 110;
    else if(kR47) width1 = 200;
    else if(kR55) width1= 200;
    else width1 = 100;
    int addMargin = 0;
    int marginW = 20;
    int marginH = 30;
    if(kR35) {
        marginW = 20 ;
        marginH = 10;
        addMargin = 20;
    } else if(kR40) {
        marginW = 20 ;
        marginH = 45;
    }
    else if(kR47) {
        marginW = 30 ;
        marginH = 70;
    }
    else if(kR55) {
        marginW = 40 ;
        marginH = 100;
    }
    else {
        marginW = 50;
        marginH = 100;
    }
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - 120);
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width - 2 * marginW, self.view.frame.size.height - 2 * marginH)];
    frame = clearView.frame;
    clearView.backgroundColor = [UIColor clearColor];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, marginH / 2 + addMargin, clearView.frame.size.width, clearView.frame.size.height - marginH / 2)];
    contentView.backgroundColor = [UIColor whiteColor];
    [clearView addSubview:contentView];
    UIImage *image = [UIImage imageNamed:@"true"];
    int imageW = clearView.frame.size.width / 3 - 20;
    UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(imageW + 30 , 0, imageW, imageW)];
    imageIcon.image = image;
    [clearView addSubview:imageIcon];

    int textWidth = 80;
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(15, imageW, contentView.frame.size.width - 15 * 2, textWidth)];
    tips.textColor = [UIColor lightGrayColor];
    tips.font = [UIFont systemFontOfSize:fontSmall];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.numberOfLines = 0;
    tips.text = NSLocalizedString(@"localized048", nil);
    [contentView addSubview:tips];
    
    UILabel *order = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(tips.frame), CGRectGetMaxY(tips.frame) + 10, CGRectGetWidth(tips.frame), textWidth)];
    order.textColor = kGColor;
    order.font = [UIFont systemFontOfSize:fontSmall];
    order.textAlignment = NSTextAlignmentCenter;
    order.numberOfLines = 0;
    _orderId = @"123478839239";
    order.text = [NSString stringWithFormat:@"%@\n\n%@", NSLocalizedString(@"localized049", nil), _orderId];
    NSDictionary *attrs = @{
                            NSFontAttributeName:[UIFont systemFontOfSize:fontSmall],
                            NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:201.0/255.0 blue:144/255.0 alpha:1.0]
                            };
    NSDictionary *subAttrs = @{
                               NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSpec]
                               };

    NSString *staticString = NSLocalizedString(@"localized049", nil);
    int start = staticString.length;
    int end = order.text.length;
    const NSRange range = NSMakeRange(start ,end - start);
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:order.text
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];

    [order setAttributedText:attributedText];
    [contentView addSubview:order];
    UILabel *delivery = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(order.frame), CGRectGetMaxY(order.frame) + 10, CGRectGetWidth(order.frame), textWidth / 1.5)];
    delivery.textColor = [UIColor lightGrayColor];
    delivery.font = [UIFont systemFontOfSize:fontSmall];
    delivery.textAlignment = NSTextAlignmentCenter;
    delivery.numberOfLines = 0;
    delivery.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"localized050", nil)];
    [contentView addSubview:delivery];
    int buttonW = contentView.frame.size.width / 3 + 30;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(onDismissButton)forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:NSLocalizedString(@"localized217",nil) forState:UIControlStateNormal];
    button.frame = CGRectMake(buttonW - 45,CGRectGetMaxY(delivery.frame) + 20,buttonW, 40);
    button.backgroundColor=kGColor;
    button.layer.cornerRadius =  4;
    button.layer.borderColor = [UIColor colorWithRed:0.9020 green:0.9020 blue:0.9020 alpha:1.0000].CGColor;
    button.layer.borderWidth = 1;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:button];
    return clearView;
}
- (UIView *) createFailDialogView{
    
    CGFloat width1 = 110;
    if(kR35) width1 = 110;
    else if(kR40) width1 = 110;
    else if(kR47) width1 = 200;
    else if(kR55) width1= 200;
    else width1 = 100;
    int addMargin = 0;
    int marginW = 20;
    int marginH = 30;
    int textWidth = 80;
    if(kR35) {
        marginW = 20 ;
        marginH = 10 + textWidth / 2;
        addMargin = 20;
    } else if(kR40) {
        marginW = 20 ;
        marginH = 45 + textWidth / 2;
    }
    else if(kR47) {
        marginW = 30 ;
        marginH = 70 + textWidth / 2;
    }
    else if(kR55) {
        marginW = 40 ;
        marginH = 100 + textWidth / 2;
    }
    else {
        marginW = 50;
        marginH = 100 + textWidth / 2;
    }
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - 120);
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width - 2 * marginW, self.view.frame.size.height - 2 * marginH)];
    frame = clearView.frame;
    clearView.backgroundColor = [UIColor clearColor];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, marginH / 2 + addMargin, clearView.frame.size.width, clearView.frame.size.height - marginH / 2)];
    contentView.backgroundColor = [UIColor whiteColor];
    [clearView addSubview:contentView];
    UIImage *image = [UIImage imageNamed:@"cancel"];
    int imageW = clearView.frame.size.width / 3 - 20;
    UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(imageW + 30 , 0, imageW, imageW)];
    imageIcon.image = image;
    [clearView addSubview:imageIcon];
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(15, imageW, contentView.frame.size.width - 15 * 2, textWidth)];
    tips.textColor = [UIColor lightGrayColor];
    tips.font = [UIFont systemFontOfSize:fontSpec];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.numberOfLines = 0;
    tips.text = NSLocalizedString(@"localized212", nil);
    [contentView addSubview:tips];
    
    UILabel *delivery = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(tips.frame), CGRectGetMaxY(tips.frame) + 10, CGRectGetWidth(tips.frame), textWidth / 1.5)];
    delivery.textColor = [UIColor lightGrayColor];
    delivery.font = [UIFont systemFontOfSize:fontSpec];
    delivery.textAlignment = NSTextAlignmentCenter;
    delivery.numberOfLines = 0;
    delivery.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"localized213", nil)];
    [contentView addSubview:delivery];
    int buttonW = contentView.frame.size.width / 3 + 30;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
                   action:@selector(onDismissButton)forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:NSLocalizedString(@"localized217",nil) forState:UIControlStateNormal];
    
    button.frame = CGRectMake(buttonW - 45,CGRectGetMaxY(delivery.frame) + 20,buttonW, 40);
    button.backgroundColor=kGColor;
    button.layer.cornerRadius =  4;
    button.layer.borderColor = [UIColor colorWithRed:0.9020 green:0.9020 blue:0.9020 alpha:1.0000].CGColor;
    button.layer.borderWidth = 1;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:button];
    return clearView;
}
-(void) onDismissButton {
    if(alertView) {
        @try {
            [alertView close];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sec = [_dataArray objectAtIndex:section];
    NSArray *list = [sec objectForKey:@"list"];
    return list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = section == 1 ? kPayFooterHeight : CGFLOAT_MIN;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    PayBaseFooterView *footerView = nil;
    
    __weak typeof(self) weakself = self;
    switch (section) {
        case 0: {
            footerView = nil;
            
            break;
        }
            
        case 1: {
            if (_countryIndex == -1 || _payIndex == -1 || _pIndex== -1) {
                footerView = nil;
            } else {
                NSMutableString *text = [NSMutableString stringWithString:NSLocalizedString(@"localized030", nil)];
                if (_payModel) {
                    [text appendFormat:@"%0.2f", _payModel.showPrice];
                    [text appendFormat:@" %@", _payModel.unit];
                }
                
                if (_payIndex == 1) {
                    if (!_paypalFooterView) {
                        _paypalFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PayPaypalFooterView"];
                        _paypalFooterView.submitBlock = ^() {
                            [weakself payWithPaypal];
                        };
                    }
                    if (_orderId) {
                        [_paypalFooterView loadPath:_payModel.paypalPath recordId:_orderId];
                    }
                    
                    footerView = _paypalFooterView;
                } else {
                    PayFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PayFooterView"];
                    view.submitBlock = ^() {
                        [weakself startPay];
                    };
                    
                    footerView = view;
                }
                footerView.label.text = text;
            }
            
            break;
        }
            
        default:
            break;
    }
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sec = [_dataArray objectAtIndex:indexPath.section];
    NSArray *list = [sec objectForKey:@"list"];
    NSDictionary *dic = [list objectAtIndex:indexPath.row];
    
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTableViewCell" forIndexPath:indexPath];
    NSInteger selectedIndex;
    switch (indexPath.section) {
        case 0:
            selectedIndex = _countryIndex;
            cell.label.text = [dic objectForKey:@"text"];
            cell.label.textColor= kGColor;
            break;
            
        case 1:
            selectedIndex = _payIndex;
            
            cell.label.text = [dic objectForKey:@"text"];
            cell.label.textColor= kGColor;
            
            cell.textfield.text = [dic objectForKey:@"text1"];

            break;
            
            
            
        case 2:

            selectedIndex = _pIndex;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 获取价格
- (void)getPrice
{
    if (_countryIndex == -1 || _payIndex == -1) {
        return;
    }
    
    NSDictionary *sec = [_dataArray objectAtIndex:0];
    NSArray *list = [sec objectForKey:@"list"];
    NSDictionary *dic = [list objectAtIndex:_countryIndex];
    NSString *from = [dic objectForKey:@"id"];
    
    sec = [_dataArray objectAtIndex:1];
    list = [sec objectForKey:@"list"];
    dic = [list objectAtIndex:_payIndex];
    NSString *method = [dic objectForKey:@"method"];
    
    _payModel = [PriceModel getPrice:from destinationCountry:[Singleton shareInstance].cardModel.countryId payType:method];
    if (_payModel) {
        [self submitOrder];
    } else {
        [self goBack];
    }
}

// 提交订单
- (void)submitOrder
{
    // 付款方式
    NSDictionary *sec = [_dataArray objectAtIndex:1];
    NSArray *list = [sec objectForKey:@"list"];
    NSDictionary *dic = [list objectAtIndex:_payIndex];
    NSString *method = [dic objectForKey:@"method"];
    
    // 产品名称
    _productName = [NSString stringWithFormat:@"Ucard-%@-%@", [Singleton shareInstance].uid, [Singleton shareInstance].cardModel.remoteCardId];
    
    // 国家
    sec = [_dataArray objectAtIndex:0];
    list = [sec objectForKey:@"list"];
    dic = [list objectAtIndex:_countryIndex];
    NSString *oCountry = [dic objectForKey:@"id"];
    
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            _orderId = [result objectForKey:@"data"];
            [self displayPrice];
        }
    }];
    [request submitOrder:[Singleton shareInstance].cardModel.remoteCardId
             paymentType:method
                   price:[NSString stringWithFormat:@"%0.2f", _payModel.realPrice]
             productName:_productName
                currency:_payModel.unit
         originalCountry:oCountry
      destinationCountry:[Singleton shareInstance].cardModel.countryId];
}
- (void)startPay
{
    NSDictionary *sec = [_dataArray objectAtIndex:1];
    NSArray *list = [sec objectForKey:@"list"];
    NSDictionary *dic = [list objectAtIndex:_payIndex];
    NSString *method = [dic objectForKey:@"method"];
    if ([method isEqualToString:@"alipay"]) {
        [self payWithAlipay];
    } else if ([method isEqualToString:@"paymill"]) {
        [self payWithPaymill];
    } else if ([method isEqualToString:@"paypal"]) {
        [self payWithPaypal];
    }
}

#pragma mark Alipay

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)payWithAlipay
{
    AlipayOrderModel *order = [[AlipayOrderModel alloc] init];
    order.partner = kAlipayPartner;
    order.seller = kAlipaySeller;
    order.tradeNO = [self generateTradeNO];
    order.productName = [NSString stringWithFormat:@"Ucard-%@-%@-%@", [Singleton shareInstance].uid, _orderId, [Singleton shareInstance].cardModel.remoteCardId];
    order.productDescription = order.productName;
    order.amount = [NSString stringWithFormat:@"%.2f", _payModel.realPrice];
    order.notifyURL = @"http://www.xxx.com"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    _swiftId = order.tradeNO;

    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = kAppScheme;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    id <DataSigner> signer = CreateRSADataSigner(kAlipayPrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    __weak typeof(self) weakself = self;
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if (resultDic.allKeys.count > 0) {
                if ([resultDic.allKeys containsObject:@"success"]) { // 客户端付款
                    NSString *success = [resultDic objectForKey:@"success"];
                    success = [success stringByReplacingOccurrencesOfString:@"%5C%22" withString:@""];
                    if ([success isEqualToString:@"true"]) {
                        [weakself payedSucc];
                        return;
                    }
                } else if ([resultDic.allKeys containsObject:@"resultStatus"]) { // webview付款
                    NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
                    if (resultStatus == 9000) {
                        [weakself payedSucc];
                        return;
                    }
                }
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"localized032", nil)
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }];
    }
}

#pragma mark Paypal

- (void)payWithPaypal
{
    __weak typeof(self) weakself = self;
    PaypalViewController *viewController = [[PaypalViewController alloc] init];
    viewController.backBlock = ^() {
        _paypalFooterView = nil;
        [_tableView reloadData];
        [viewController dismissViewControllerAnimated:NO completion:nil];
    };
    viewController.finishedBlock = ^() {
        [viewController dismissViewControllerAnimated:NO completion:nil];
        [weakself showFinished: YES];
    };
    viewController.webView = _paypalFooterView.webView;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark Paymill

- (void)payWithPaymill
{
    __weak typeof(self) weakself = self;
    PayMillViewController *viewController = [[PayMillViewController alloc] init];
    viewController.finishedBlock = ^(NSString *swiftId) {
        _swiftId = swiftId;
        [weakself payedSucc];
        [viewController dismissViewControllerAnimated:NO completion:nil];
    };
    viewController.orderId = _orderId;
    viewController.price = _payModel.realPrice;
    viewController.unit = _payModel.unit;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark Wechat
- (void)bizPay {
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
    
}
#pragma mark 付款成功

- (void)payedSucc
{
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request completion:^(id result, BOOL succ) {
            [weakself showFinished : succ];
    }];
    [request finishPay:_orderId swiftNumber:_swiftId];
}

- (void)showFinished :(BOOL) isSuccess
{
    [self aMethod:TRUE];
}

@end
