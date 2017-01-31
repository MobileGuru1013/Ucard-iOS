//
//  CardNewBackView.m
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CardNewBackView.h"
#import "NSString+Size.h"

@interface CardNewBackView ()
{
    UIButton *_textView;
    UIButton *_signImageView;
    UIButton *_addressBg;
    UIImageView *_bgImageView;
    CGFloat _addressFontSize;
    NSString *_addressText;
    CGFloat _addressHeight;
    UIButton*  _locationBg ;
    UIButton*  _stamp ;
}
@end

@implementation CardNewBackView
bool isBlackPaint = TRUE;
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat height3;
        int bonusMargin;
        int signMargin;
        CGFloat margin;
        int adjustHeight = 0;
        int rawMargin = kCardBgMargin;
        int locationMargin = 0;
        
        if(kR35) {
            height3 = 30;
            bonusMargin = 0;
            adjustHeight = 8;
            signMargin = 20;
        }
        else if(kR40) {
            height3 = 30;
            adjustHeight = 10;
            signMargin = 20;
        }
        else if(kR47) {
            bonusMargin = 4;
            height3 = 40;
            signMargin = 30;
            adjustHeight = 0;
        }
        else if(kR55) {
            bonusMargin = 7;
            height3 = 40;
            signMargin = 35;
            adjustHeight = -10;
            locationMargin = 10;
        }
        
        
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bgImageView];
        
        margin = rawMargin * frame.size.width / kScreenWidth;
        CGRect oldFrame = kCardTextFrame;
        CGRect frameTxt = [self getTextViewFrame:frame];
        bonusMargin += margin;
        
        _textView = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetMinX(frameTxt)  - margin / 2) + bonusMargin, CGRectGetMinY(frameTxt) - margin / 2 + bonusMargin,CGRectGetWidth(frameTxt) + margin - 3 * bonusMargin / 2, CGRectGetHeight(frameTxt) + margin - bonusMargin - height3 + adjustHeight)];
        CGRect viewFrame = _textView.frame;
        [_textView addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
        _textView.tag = 0;
        [self addSubview:_textView];
        
        _signImageView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_textView.frame), CGRectGetMaxY(_textView.frame) + signMargin / 2, CGRectGetWidth(_textView.frame) - signMargin, height3 - signMargin / 6)];
        _signImageView.tag = 1;
        [_signImageView addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_signImageView];
        
        _addressBg = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame) + margin + bonusMargin / 4, CGRectGetMaxY(_signImageView.frame) + 0.5 - 26 - 110 + bonusMargin + height3 + adjustHeight * 2 + locationMargin / 5,CGRectGetWidth(frame) - CGRectGetMaxX(_textView.frame) - margin - margin - bonusMargin / 2, 100 + locationMargin * 3)];
        _addressBg.tag = 2;
        [_addressBg addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addressBg];
        
        _locationBg = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_textView.frame), CGRectGetMaxY(_signImageView.frame) + signMargin / 12 + adjustHeight / 2 + locationMargin, CGRectGetWidth(_textView.frame), CGRectGetHeight(_signImageView.frame) - signMargin / 6)];
        _locationBg.tag = 3;
        [_locationBg addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_locationBg];
        
        
        _stamp = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame)+(kR55 ? 90:60),  CGRectGetMinY(frameTxt) - margin / 2 + bonusMargin,40,40)];
        _stamp.tag = 4;
        [_stamp addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_stamp];
        
        
    }
    
    return self;
}
-(CGRect) getTextViewFrame: (CGRect) viewFrame {
    
    CGFloat widths;
    CGFloat widths1;
    
    if(kR35) widths = 15;
    else if(kR40) widths =20;
    else if(kR47) widths = 25;
    else if(kR55) widths = 35;
    
    if(kR35) widths1 = 20;
    else if(kR40) widths1 =20;
    else if(kR47) widths1 = 20;
    else if(kR55) widths1 = 20;
    
    
    CGRect frame = CGRectMake(0, 0, 0, 0);
    frame = CGRectMake(kCardBgMargin + 5, kCardBgMargin + 5, (viewFrame.size.width - kCardBgMargin * 2) * 0.6 - 5 * 2, kCardHeight * viewFrame.size.width / kCardWidth - 5.0 - 44.0 - 30.0 - 5 * 2);
    return frame;
}
- (void)popView:(UIButton *)button

{
    if (self.toolBlock) {
        self.toolBlock(button.tag);
    }
}

- (void)setContent
{
    [self performSelectorInBackground:@selector(setContentInBackground) withObject:nil];
}
- (void)setContent: (BOOL *) _isBlack
{
    isBlackPaint = _isBlack;
    [self performSelectorInBackground:@selector(setContentInBackground) withObject:nil];
}
- (void)setContentInBackground
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, kCardWidth / CGRectGetWidth(self.frame));
    
    // bg
    [[UIImage imageNamed:@"card-back-bg@2x3x"] drawInRect:self.bounds];
    
    // 文本
    NSArray *fontArray = [Constants getFont];
    NSDictionary *fontDic = [fontArray objectAtIndex:[Singleton shareInstance].cardModel.fontIndex];
    NSArray *sizeArray = [Constants getSize];
    UIFont *font = [UIFont fontWithName:fontDic.allKeys.firstObject size:[[sizeArray objectAtIndex:[Singleton shareInstance].cardModel.sizeIndex] floatValue]];
    UIColor *paintColor;
    if (isBlackPaint) {
        paintColor = [UIColor blackColor];
    } else {
        paintColor = [UIColor blueColor];
    }
    [[Singleton shareInstance].cardModel.text drawInRect:CGRectMake(CGRectGetMinX(_textView.frame) + 2, CGRectGetMinY(_textView.frame) + 2, CGRectGetWidth(_textView.frame) - 4, CGRectGetHeight(_textView.frame) - 4) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName: paintColor}];
    
    // 签名
    CGFloat signOffsetY = 0;
    int locationOffsetX = 10;
    int locationOffsetY = 7;
    int subSize = 7;
    if(kR35) {
        locationOffsetX = 10;
        locationOffsetY = 5;
        subSize = 9;
    }
    else if(kR40) {
        locationOffsetX = 10;
        locationOffsetY = 4;
        subSize = 10;
    }
    else if (kR47) {
        signOffsetY = -2;
        locationOffsetX = 10;
        locationOffsetY = 7;
        subSize = 12;
    }
    else if (kR55) {
        subSize = 13;
        signOffsetY = 0;
        locationOffsetX = 15;
        locationOffsetY = 7;
    }
    CGFloat dx = [Singleton shareInstance].cardModel.signImage.size.height / [Singleton shareInstance].cardModel.signImage.size.width;
    CGFloat realWidth = CGRectGetHeight(_signImageView.frame) / dx;
    CGFloat x = (CGRectGetWidth(_signImageView.frame) - realWidth) / 2.0;
    [[Singleton shareInstance].cardModel.signImage drawInRect:CGRectMake(CGRectGetMinX(_signImageView.frame) + x, CGRectGetMinY(_signImageView.frame) - signOffsetY, realWidth, CGRectGetHeight(_signImageView.frame))];
    
    float locationSize = [[sizeArray objectAtIndex:[Singleton shareInstance].cardModel.sizeIndex] floatValue];
    locationSize = subSize;
    UIFont *locationFont = [UIFont boldSystemFontOfSize:locationSize];
    [[Singleton shareInstance].cardModel.locationName drawInRect:CGRectMake(CGRectGetMinX(_locationBg.frame) + locationOffsetX, CGRectGetMinY(_locationBg.frame) + locationOffsetY, CGRectGetWidth(_locationBg.frame) - locationOffsetX, CGRectGetHeight(_locationBg.frame) - locationOffsetY * 2) withAttributes:@{NSFontAttributeName: locationFont, NSForegroundColorAttributeName: [UIColor colorWithRed:102.0/255.0 green:201.0/255.0 blue:144/255.0 alpha:1.0]}];
    // 地址
    CGFloat labelCount = 5;
    CGFloat height = CGRectGetHeight(_addressBg.frame) / labelCount;
    NSMutableArray *textArray = [NSMutableArray array];
    for (NSInteger i = 0; i < labelCount; i++) {
        NSMutableString *text = [NSMutableString string];
        switch (i) {
                
            case 0: {
                if ([Singleton shareInstance].cardModel.firstName) {
                    [text appendString:[Singleton shareInstance].cardModel.firstName];
                }
                if ([Singleton shareInstance].cardModel.middleName) {
                    [text appendFormat:@" %@", [Singleton shareInstance].cardModel.middleName];
                }
                if ([Singleton shareInstance].cardModel.lastName) {
                    [text appendFormat:@" %@", [Singleton shareInstance].cardModel.lastName];
                }
                
                break;
            }
                
            case 1: {
                if ([Singleton shareInstance].cardModel.building) {
                    [text appendString:[Singleton shareInstance].cardModel.building];
                }
                
                break;
            }
                
            case 2: {
                if ([Singleton shareInstance].cardModel.street) {
                    [text appendString:[Singleton shareInstance].cardModel.street];
                }
                
                break;
            }
                
            case 3: {
                if ([Singleton shareInstance].cardModel.city) {
                    [text appendString:[Singleton shareInstance].cardModel.city];
                }
                if ([Singleton shareInstance].cardModel.province) {
                    [text appendFormat:@" %@", [Singleton shareInstance].cardModel.province];
                }
                if ([Singleton shareInstance].cardModel.zip) {
                    [text appendFormat:@" %@", [Singleton shareInstance].cardModel.zip];
                }
                
                break;
            }
                
            case 4: {
                if ([Singleton shareInstance].cardModel.country) {
                    [text appendString:[Singleton shareInstance].cardModel.country];
                }
                
                break;
            }
                
            default:
                break;
        }
        
        if (text.length > 0) {
            [textArray addObject:text];
        }
    }
    
    _addressText = [textArray componentsJoinedByString:@"\n"];
    _addressFontSize = 10;
    CGRect rect = CGRectMake(CGRectGetMinX(_addressBg.frame), CGRectGetMinY(_addressBg.frame), CGRectGetWidth(_addressBg.frame), height * labelCount);
    [self getBottomText:rect.size];
    [_addressText drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_addressFontSize],NSForegroundColorAttributeName: paintColor}];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [[Singleton shareInstance].cardModel screenshotBack:image];
    
    // 加入二维码等信息
    NSDictionary *fontDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:6.5], NSForegroundColorAttributeName:[UIColor grayColor]};
    NSString *text = [[Singleton shareInstance].cardModel.country isEqualToString:@"China"] ? @"1.扫描二维码或打开Ucard手机应用\n2.进入“我”-“查收”-搜索SN号-“确认收货”" : @"1.Scanning QR code or \nOpen Ucard App\n2.Account \"me\"-\"receive\"-Search SN No.–\"Received\"";
    CGFloat barCodeWidth = 30;
    CGRect frame = CGRectMake(CGRectGetMinX(_addressBg.frame), CGRectGetMaxY(_addressBg.frame) + 2, CGRectGetWidth(_addressBg.frame) - barCodeWidth + 4, 32);
    [text drawInRect:frame withAttributes:fontDictionary];
    
    NSString *sn = [NSString stringWithFormat:@"SN: %@", [Singleton shareInstance].cardModel.remoteCardId];
    CGRect snFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), CGRectGetWidth(frame), 12);
    [sn drawInRect:snFrame withAttributes:fontDictionary];
    
    frame = CGRectMake(CGRectGetMaxX(frame) + 2, CGRectGetMinY(frame) + 3, barCodeWidth, barCodeWidth);
    [[UIImage imageNamed:@"barcode"] drawInRect:frame];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    [[Singleton shareInstance].cardModel screenshotUploadBack:image];
    
    UIGraphicsEndImageContext();
    
    [self performSelectorOnMainThread:@selector(showBackImage) withObject:nil waitUntilDone:YES];
}

- (void)getBottomText:(CGSize)size {
    CGSize fontSize = [@"a" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_addressFontSize]}];
    double finalHeight = size.height;
    CGSize theStringSize = [_addressText boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_addressFontSize]} context:nil].size;
    _addressHeight = theStringSize.height;
    int newLinesToPad = (finalHeight - theStringSize.height) / fontSize.height;
    for (int i = 0; i < newLinesToPad; i++) {
        _addressText = [NSString stringWithFormat:@" \n%@", _addressText];
    }
    if (theStringSize.height > size.height) {
        _addressFontSize -= 0.1;
        [self getBottomText:size];
    }
}

- (void)showBackImage
{
    UIImage *image = [UIImage imageWithContentsOfFile:[[Singleton shareInstance].cardModel backPath]];
    _bgImageView.image = image;
}

+ (BOOL)isTextMore:(NSString *)string font:(UIFont *)font
{
    CGFloat height = [string getHeightOfFont:font width:CGRectGetWidth(kCardTextFrame)];
    if (height > CGRectGetHeight(kCardTextFrame)) {
        return YES;
    }
    return NO;
}



-(CGRect) getTextContentFrame {
    return CGRectMake(CGRectGetMinX(_textView.frame) + 2, CGRectGetMinY(_textView.frame) + 2, CGRectGetWidth(_textView.frame) - 4, CGRectGetHeight(_textView.frame) - 4);
}

@end
