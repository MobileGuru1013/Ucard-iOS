//
//  AddressPopView.m
//  Ucard
//
//  Created by WuLeilei on 15/4/24.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "StampPopView.h"
#import "AddressTextFieldCell.h"
#import "AddressCountryCell.h"
#import "KeyValueModel.h"
#import "TPKeyboardAvoidingTableView.h"

@interface StampPopView () <UITableViewDataSource, UITableViewDelegate>
{
    TPKeyboardAvoidingTableView *_tableView;
    NSMutableArray *_dataArray;
    UIButton *ticChina, *ticICE;
}
@end

@implementation StampPopView

- (id)initWithFrame:(CGRect)frame bgFrame:(CGRect)bgFrame title:(NSString *)title
{
    if (self = [super initWithFrame:frame bgFrame:bgFrame title:title]) {
        int flagHeight = 50;
        
        if (kR35) {
            flagHeight = 100;
        } else if (kR40) {
            flagHeight = 100;
        } else if (kR47) {
            flagHeight = 150;
        } else if (kR55) {
            flagHeight = 200;
        }
        UIView *chinaView = [[UIView alloc] initWithFrame:CGRectMake(0,45,CGRectGetWidth(bgFrame) / 2, 10 *2 + 30 + flagHeight + 20)];
        ticChina = [[UIButton alloc] initWithFrame: CGRectMake((CGRectGetWidth(chinaView.frame) - 30 ) / 2, 10, 30, 30)];
        
        [ticChina addTarget:self action:@selector(chooseChinaFlag) forControlEvents:UIControlEventTouchUpInside];
        [ticChina setImage:[UIImage imageNamed:@"unselect_icon"] forState:UIControlStateNormal];
        [ticChina setImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateSelected];
        UIImageView *flagChina = [[UIImageView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(ticChina.frame) + 10, (CGRectGetWidth(chinaView.frame) - 20), flagHeight )];
        
        flagChina.image = [UIImage imageNamed:@"china_flag"];
         flagChina.contentMode = UIViewContentModeScaleAspectFit;
        [chinaView addSubview: ticChina];
        [chinaView addSubview: flagChina];
        UIView *iceView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(chinaView.frame), 45,CGRectGetWidth(bgFrame)/2, 10 *2 + 30 + flagHeight + 20)];
        ticICE = [[UIButton alloc] initWithFrame: CGRectMake((CGRectGetWidth(chinaView.frame) - 30 ) / 2, 10, 30, 30)];
        [ticICE addTarget:self action:@selector(chooseIcelandFlag) forControlEvents:UIControlEventTouchUpInside];
        [ticICE setImage:[UIImage imageNamed:@"unselect_icon"] forState:UIControlStateNormal];
        [ticICE setImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateSelected];
        UIImageView *flagICE = [[UIImageView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(ticICE.frame) + 10, (CGRectGetWidth(iceView.frame) - 20), CGRectGetHeight(iceView.frame) - 60 - 10 )];
        
        flagICE.image = [UIImage imageNamed:@"iceland_flag"];
        flagICE.contentMode = UIViewContentModeScaleAspectFit;
        [iceView addSubview: ticICE];
        [iceView addSubview: flagICE];
        [_bgView addSubview:iceView];
        [_bgView addSubview:chinaView];
        CGRect frame = _bgView.frame;
        frame.size.height = CGRectGetMaxY(chinaView.frame) + 60;
        _bgView.frame = frame;
        _doneButton.titleLabel.text =NSLocalizedString( @"localized223",nil);
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

// 监听文字更改
-(void) chooseChinaFlag {
    ticChina.selected = YES;
    ticICE.selected = NO;
    if (self.chooseChina) {
        self.chooseChina();
    }
}
-(void) chooseIcelandFlag {
    ticICE.selected = YES;
    ticChina.selected = NO;    if (self.chooseIceland) {
        self.chooseIceland();
    }
}

@end
