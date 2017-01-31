//
//  CardBasePopView.m
//  Ucard
//
//  Created by Conner Wu on 15/4/20.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CardBasePopView.h"
#import "UIImage+Screenshot.h"
#import "GPUImageiOSBlurFilter.h"
#import "SignPopView.h"
//#import "AddressPopView.m"
#import "StampPopView.h"

@interface CardBasePopView ()

@end

@implementation CardBasePopView
{
    
    
    SignPopView*signpopView;
    //    AddressPopView *addresspopView;
    StampPopView*stampopView;
}


- (id)initWithFrame:(CGRect)frame bgFrame:(CGRect)bgFrame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *image = [UIImage screenshot];
        
        GPUImageiOSBlurFilter *filter = [[GPUImageiOSBlurFilter alloc] init];
        filter.blurRadiusInPixels = 11;
        image = [filter imageByFilteringImage:image];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.alpha = 0.9;
        imageView.image = image;
        [self addSubview:imageView];
        
        _bgView = [[UIView alloc] initWithFrame:bgFrame];
        _bgView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        _bgView.layer.borderWidth = 1;
        [self addSubview:_bgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:titleLabel];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(CGRectGetWidth(bgFrame) - 50 - 9+ 20,(CGRectGetHeight(titleLabel.frame) - 25) / 2, 20, 20);
        [cancelButton setImage:[UIImage imageNamed:@"Signature_cancel"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:cancelButton];
        _cancelButton = cancelButton;
        
        
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(9, (CGRectGetHeight(titleLabel.frame) - 25) / 2, 50, 25);
        closeButton.layer.cornerRadius = 3;
        closeButton.layer.masksToBounds = YES;
        closeButton.titleLabel.textColor = [UIColor whiteColor];
        closeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        closeButton.backgroundColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1];
        [closeButton setTitle:NSLocalizedString(@"localized073", nil) forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:closeButton];
        _closeButton = closeButton;
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(CGRectGetWidth(bgFrame) - 50 - 9, (CGRectGetHeight(titleLabel.frame) - 25) / 2, 50, 25);
        doneButton.layer.cornerRadius = closeButton.layer.cornerRadius;
        doneButton.layer.masksToBounds = YES;
        doneButton.titleLabel.textColor = [UIColor whiteColor];
        doneButton.titleLabel.font = closeButton.titleLabel.font;
        doneButton.backgroundColor = kGreenColor;
        [doneButton setTitle:NSLocalizedString(@"localized117", nil) forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:doneButton];
        _doneButton = doneButton;
        
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(titleLabel.frame), 1)];
        line.backgroundColor = [UIColor colorWithCGColor:_bgView.layer.borderColor];
        [_bgView addSubview:line];
        _line = line;
        
        //
        //        if (check==signpopView) {
        //            [closeButton setHidden:YES];
        //            [doneButton setHidden:YES];
        //            }
        //
        //       else if (check==stampopView) {
        //            [closeButton setHidden:NO];
        //            [doneButton setHidden:NO];
        //        }
        //
        
        
        
    }
    return self;
}
- (void) adjustButton {
    int width = _bgView.frame.size.width;
    int height = _bgView.frame.size.height;
    _closeButton.frame = CGRectMake((width - 2 * CGRectGetWidth(_closeButton.frame) - 30) / 2, height -  (60 -_closeButton.frame.size.height) / 2 - _closeButton.frame.size.height, _closeButton.frame.size.width, _closeButton.frame.size.height);
    _doneButton.frame = CGRectMake(CGRectGetMaxX(_closeButton.frame) + 30, CGRectGetMinY(_closeButton.frame), _closeButton.frame.size.width, _closeButton.frame.size.height);
    _line.hidden = YES;
}
- (void) adjustButtonStamp {
    int width = _bgView.frame.size.width;
    int height = _bgView.frame.size.height;
    _doneButton.frame = CGRectMake((width - 100) / 2, height -  (60 -_closeButton.frame.size.height) / 2 - _closeButton.frame.size.height, 100, _closeButton.frame.size.height);
    [_doneButton setTitle:NSLocalizedString(@"localized223", nil) forState:UIControlStateNormal];
    _closeButton.hidden = YES;
    _line.hidden = YES;
}
- (void)dismiss
{
    if (self.closeBlock) {
        self.closeBlock(NO);
    }
}

- (void)done
{
    if (self.closeBlock) {
        [Singleton shareInstance].cardModel.hasUploaded = NO;
        [[Singleton shareInstance].cardModel updateData];
        
        self.closeBlock(YES);
    }
}
-(void)showCancel
{
    [_cancelButton setHidden:YES];
    [_closeButton setHidden:NO];
    [_doneButton setHidden:NO];
    
}
-(void)hideCancel
{
    [_cancelButton setHidden:NO];
    [_closeButton setHidden:YES];
    [_doneButton setHidden:YES];
    
}


@end
