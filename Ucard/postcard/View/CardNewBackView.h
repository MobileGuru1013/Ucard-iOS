//
//  CardNewBackView.h
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCardBgMargin 15.0
#define kCardTextFrame CGRectMake(kCardBgMargin + 5, kCardBgMargin + 5, (kScreenWidth - kCardBgMargin * 2) * 0.6 - 5 * 2, kCardHeight * kScreenWidth / kCardWidth - 5.0 - 44.0 - 30.0 - 5 * 2)

@interface CardNewBackView : UIView

@property (nonatomic, strong) void (^toolBlock) (NSUInteger index);

- (void)setContent;
- (void)setContent: (BOOL *) _isBlack;
+ (BOOL)isTextMore:(NSString *)string font:(UIFont *)font;
-(CGRect) getTextContentFrame;



@end
