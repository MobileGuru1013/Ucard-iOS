//
//  Constants.h
//
//
//  Created by WuLeilei.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityButton.h"

#define kFileURL @"http://www.ucardstore.com/"
#define kApiURL [NSString stringWithFormat:@"%@app/", kFileURL]
#define kPublicDBVersion 0.2
#define kUserDBVersion 1.0
#define kWeiboAppKey @"1097336707"
#define kWeiboRedirectURI @"http://www.ucardstore.com"
#define kWeixinAppKey @"wxb0e52176f9035f39"
#define kSupportEmail @"support@ucardstore.com"

#define kAppScheme @"ucardapp"
#define kAlipayPartner @"2088911758345595"
#define kAlipaySeller @"info@ucardstore.com"
#define kAlipayPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALiVdsDBNE4uh2v+2obGG/pW0IcwBfE9UpESrAjcamwkDeuZjScgPJmryUj/62Q2iwpAzi/ZsDP7ZIYP8jN0Kj3Yfd76d41p/gwg7H6iw6zVP8ADkPUtyK8BEsdwBTJ5+OGW0I81JLPQVH71OQSS5RW9usjE3s2CpQHkSvsePA99AgMBAAECgYEAtYlSFPsvfSDn0UACHgDjbU9KoVqKzZrZBJMPnVtiU18WTbtkBrH+x8gbG++Oy62VC412+7qmQEmjsPIn65D5JNSZQ8EO4r+mob65n8NXmya6srHkQPNvEgCY1H5sbwa2vLYu5X+3E7GxO1t0gX0jn9WvDy/PgRpICa5U5oOkRuECQQDa4JPC5VOM0KuR7xhHaI6NaKTRhYSqBy92khICW8JV52YEGkeQU8LtyRpbHTklvvhMwkTHM1QWGK+VAvuPIsO1AkEA1+PnBSat7LmmfOu7QumIJo63Fr0wPq3J4LwAt1KNzzNaKrqWJbKWTUYmKL8+rSpSOpDjikV+49fsl2PokXmJqQJAQYM2tv8tItjSgbuu6LDC+lB4BL6SFtJPwo22Fj6gzFWWk2PKR8jKb6Hh4aO9ly6x40fCjl0ure51n4RlB1LAgQJAcGnmKEN8us/shg2FI5FQaKtVYIzAa1K41MFwKgTdfG+D2s3vUs/L/Y6yXfM/IpHv4TkCkkQfj2omcqn+NomviQJAAJe8I+ml8HB6O+UgUUMJls+mG7SHdbUdP1MBmDnBuwUWdy444MK/wgRfvxS3OpYChgHqlx8yPLOjLcIGonCUjQ=="

#define kPaymillPublicKey @"10181022285fe2cfbedee37a7a07789d"
#define kPaymillTestModel YES

#define kGreenColor [UIColor colorWithRed:0.2902 green:0.8431 blue:0.4471 alpha:1.0000]
#define kRedColor [UIColor colorWithRed:0.95 green:0 blue:0 alpha:1]
#define kBgGrayColor [UIColor colorWithRed:0.9686 green:0.9686 blue:0.9686 alpha:1.0000]
#define kTextGrayColor [UIColor colorWithRed:0.6275 green:0.6235 blue:0.6275 alpha:1.0000]
#define kBlueColor [UIColor colorWithRed:0.204 green:0.525 blue:0.824 alpha:1]

#define kCardWidth 1748.0
#define kCardHeight 1240.0

#define kCNFonts @{@"FZJLJW--GB1-0": @"手写体", @"STHeitiSC-Light": @"黑体"}

#define kAppURL @"https://itunes.apple.com/us/app/usard-app/id966372400?l=zh&ls=1&mt=8"

@interface Constants : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (ActivityButton *)createGreenButton:(CGRect)frame title:(NSString *)title sel:(SEL)sel target:(id)target;
+ (NSArray *)getSize;
+ (NSArray *)getFont;
+ (BOOL)isCNLanguage;
+ (NSString *)handleString:(NSString *)string;
+ (NSString *)getSexDes:(NSInteger)sex;
+ (NSString *)getFileURLString:(NSString *)path;
+ (void)setHeaderImageView:(UIImageView *)imageView path:(NSString *)path;
+ (void)setImageView:(UIImageView *)imageView path:(NSString *)path;
+ (UIButton *)createButton:(CGRect)frame title:(NSString *)title target:(id)target sel:(SEL)sel color:(UIColor *)color;
+ (void)setPublicButtonColor:(UIColor *)color button:(UIButton *)button;
+ (NSString *)getLocalizedCountry:(NSString *)code;
+ (void)showTipsMessage:(NSString *)message;
+ (NSString *)getSmallImageURLString:(NSString *)path;

@end
