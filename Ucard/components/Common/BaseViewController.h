//
//  BaseViewController.h
//  Parents
//
//  Created by WuLeilei on 14/12/16.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UITextFieldDelegate>

- (void)showNavLogo;
-(void) hideNavLogo;

-(void) hideRightButton;
- (void)showNotifocations;
@end
