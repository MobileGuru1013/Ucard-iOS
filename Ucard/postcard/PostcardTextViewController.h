//
//  PostcardTextViewController.h
//  Ucard
//
//  Created by WuLeilei on 15/4/19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommonBackViewController.h"

@interface PostcardTextViewController : CommonBackViewController

@property (nonatomic, strong) void (^updateTextBlock) ();
-(void) setTextContentFrame: (CGRect) frame;
@end
