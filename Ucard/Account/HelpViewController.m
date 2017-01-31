//
//  HelpViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/5/2.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "HelpViewController.h"
#import <CFNetwork/CFNetwork.h>
#import "SKPSMTPMessage.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "GCPlaceholderTextView.h"
#import "NSData+Base64Additions.h"
#import "SVProgressHUD.h"

@interface HelpViewController () <SKPSMTPMessageDelegate, UITextViewDelegate>
{
    UITextField *_textField;
    GCPlaceholderTextView *_textView;
}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideRightButton];
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    
    CGFloat width;
    if(kR35) width = 20;
    else if(kR40) width =20;
    else if(kR47) width =  20;
    else if(kR55) width = 20;
    
    CGFloat height;
    if(kR35) height = 20;
    else if(kR40) height =50;
    else if(kR47) height =  150;
    else if(kR55) height = 220;
    
    
    CGFloat htext;
    if(kR35) htext = 40;
    else if(kR40) htext =50;
    else if(kR47) htext =  50;
    else if(kR55) htext = 60;
    
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
    
    
    UILabel* titlelb=[[UILabel alloc] initWithFrame:CGRectMake(width, 20, kScreenWidth - width * 2, 30)];
    titlelb.text=@"Title";
    titlelb.textColor=[UIColor grayColor];
    titlelb.font=[UIFont fontWithName:@"System" size:fontNormal];
    
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(width,CGRectGetMaxY(titlelb.frame), kScreenWidth - width * 2, htext)];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.borderColor = [UIColor colorWithRed:0.843 green:0.843 blue:0.843 alpha:1].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.layer.cornerRadius = 5;
    _textField.layer.masksToBounds = YES;
    _textField.placeholder = NSLocalizedString(@"localized089", nil);
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5, CGRectGetHeight(_textField.frame))];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:titlelb];
    [self.view addSubview:_textField];
    
    
    
    UILabel* contentlb=[[UILabel alloc] initWithFrame:CGRectMake(width, CGRectGetMaxY(_textField.frame) + 20, CGRectGetWidth(_textField.frame), 30)];
    contentlb.text=@"Content";
    contentlb.textColor=[UIColor grayColor];
    contentlb.font=[UIFont fontWithName:@"System" size:fontNormal];
    
    _textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(width, CGRectGetMaxY(contentlb.frame) , CGRectGetWidth(_textField.frame), 160+height)];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.borderColor = [UIColor colorWithRed:0.843 green:0.843 blue:0.843 alpha:1].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    _textView.placeholder = NSLocalizedString(@"localized090", nil);
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    
    
    
    [self.view addSubview:contentlb];
    [self.view addSubview:_textView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMinX(_textView.frame), CGRectGetMaxY(_textView.frame) + 20, CGRectGetWidth(_textView.frame), htext+10);
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    button.backgroundColor=kGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"localized022", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)submit
{
    NSString *title = _textField.text;
    NSString *content = _textView.text;
    
    NSString *tips = nil;
    if (title.length == 0) {
        tips = NSLocalizedString(@"localized091", nil);
    } else if (content.length == 0) {
        tips = NSLocalizedString(@"localized092", nil);
    }
    
    if (tips) {
        [Constants showTipsMessage:tips];
        return;
    }
    
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
    
    [[Singleton shareInstance] startLoadingInView:self.view];
    
    SKPSMTPMessage *SMTPMessage = [[SKPSMTPMessage alloc] init];
    SMTPMessage.fromEmail = @"15827110221@126.com";
    SMTPMessage.toEmail = kSupportEmail;
    SMTPMessage.relayHost = @"smtp.126.com";
    SMTPMessage.relayPorts = @[@25];
    SMTPMessage.requiresAuth = YES;
    SMTPMessage.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
    
    if (SMTPMessage.requiresAuth) {
        SMTPMessage.login = @"15827110221@126.com";
        SMTPMessage.pass = @"430115";
    }
    
    SMTPMessage.subject = title;
    SMTPMessage.delegate = self;
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain; charset=UTF-8", kSKPSMTPPartContentTypeKey,
                               content, kSKPSMTPPartMessageKey,
                               @"8bit", kSKPSMTPPartContentTransferEncodingKey,nil];
    
    SMTPMessage.parts = [NSArray arrayWithObjects:plainPart, nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SMTPMessage send];
    });
}

- (void)messageSent:(SKPSMTPMessage *)message
{
    [[Singleton shareInstance] stopLoading];
    
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"localized093", nil)];
    
    [self goBack];
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    [[Singleton shareInstance] stopLoading];
    
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"localized094", nil)];
    
    NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
}

@end
