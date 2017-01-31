//
//  PayPaypalFooterView.h
//  Ucard
//
//  Created by WuLeilei on 15/5/27.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PayBaseFooterView.h"

@interface PayPaypalFooterView : PayBaseFooterView

@property (nonatomic, strong) UIWebView *webView;

- (void)loadPath:(NSString *)path recordId:(NSString *)recordId;

@end
