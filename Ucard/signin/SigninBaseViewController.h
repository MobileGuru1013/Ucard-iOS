//
//  SigninBaseViewController.h
//  Ucard
//
//  Created by Conner Wu on 15-4-7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyPlaceholderValueModel.h"
#import "ActivityButton.h"
#import "SignupTableViewCell.h"

@interface SigninBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    
    BOOL checked;
    UIImageView *backgroundview;
    UILabel *_titleLabel;
    UIImageView *_logoImageView;
    NSArray *_dataArray;
    UILabel *_tipsLabel;
    UIButton *_tipsButton;
    ActivityButton *_signButton;
    UITableView *_tableView;
    UIImageView *_coverImageView;
    
    UITextField *_textField;
    UIView * viewpoop;
    
    ActivityButton *_submitButton;
    
    int fontSmall;
    int fontNormal;
}

- (void)createOtherView:(NSString *)title sel:(SEL)sel signup:(BOOL)signup;
- (void)signinMethod:(NSString *)user password:(NSString *)password;
- (void)signinSNS:(NSString *)type uid:(NSString *)uid button:(ActivityButton *)button;
- (void)checkSNS:(NSString *)type uid:(NSString *)uid nickname:(NSString *)nickname andEmail: (NSString *) _email andImagePath: (NSString *) _imagePath;
-(void) showAlertWeibo: (NSString *) _username andUDID: (NSString *) _udid;
-(void) showForgetPassword;
- (void)checkAutoSignin;
@end
