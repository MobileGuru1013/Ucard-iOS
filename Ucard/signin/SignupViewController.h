//
//  SignupViewController.h
//  Ucard
//
//  Created by Conner Wu on 15-4-8.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SigninBaseViewController.h"

@interface SignupViewController : SigninBaseViewController
@property (nonatomic, strong) void (^goBackBlock) ();
@end
