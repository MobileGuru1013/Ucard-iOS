//
//  CardBasePopView.h
//  Ucard
//
//  Created by Conner Wu on 15/4/20.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPopWidth kScreenWidth - 10 * 2

@interface CardBasePopView : UIView
{
    UIView *_bgView;
    UIView *_line;
    UIButton *_doneButton;
    UIButton *_closeButton;
    UIButton* _cancelButton;
    
    
}

@property (nonatomic, strong) void (^closeBlock) (BOOL done);

- (id)initWithFrame:(CGRect)frame bgFrame:(CGRect)bgFrame title:(NSString *)title;
- (void)done;
- (void) adjustButton;
- (void) adjustButtonStamp;
-(void)showCancel;
-(void)hideCancel;

@end
