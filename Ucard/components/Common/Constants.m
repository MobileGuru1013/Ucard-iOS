//
//  Constants.m
//
//
//  Created by WuLeilei.
//  Copyright (c) 2014年 WuLeilei. All rights reserved.
//

#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "CountryModel.h"

@implementation Constants

/**
 *  用颜色创建图片
 *
 *  @param color 图片颜色
 *  @param size  图片尺寸
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    // Create a context of the appropriate size
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    
    // Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    // Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    // Snap the picture and close the context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (ActivityButton *)createGreenButton:(CGRect)frame title:(NSString *)title sel:(SEL)sel target:(id)target
{
    ActivityButton *button = [[ActivityButton alloc] init];
    button.frame = frame;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:[Constants imageWithColor:kWhiteColor size:button.frame.size] forState:UIControlStateNormal];
    [button setTitleColor: kGColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}

+ (NSArray *)getSize
{
    return @[@"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30"];
}

+ (NSArray *)getFont
{
    NSMutableArray *cnArray = [NSMutableArray array];
    NSMutableArray *enArray = [NSMutableArray array];
    NSMutableArray *otherArray = [NSMutableArray array];
    NSArray *names = [UIFont familyNames];
    for (NSString *n in names) {
        NSArray *arr = [UIFont fontNamesForFamilyName:n];
        for (NSString *f in arr) {
            NSLog(@"%@", f);
            if ([kENFonts.allKeys containsObject:f]) { // 英文字体
                [enArray addObject:@{f: f}];
            } else if ([kCNFonts.allKeys containsObject:f]) { // 中文字体
                [cnArray addObject:@{f: [Constants isCNLanguage] ? [kCNFonts objectForKey:f] : f}];
            } else { // 其它字体
                [otherArray addObject:@{f: f}];
            }
        }
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    if ([Constants isCNLanguage]) {
        [returnArray addObjectsFromArray:cnArray];
        [returnArray addObjectsFromArray:enArray];
    } else {
        [returnArray addObjectsFromArray:enArray];
        [returnArray addObjectsFromArray:cnArray];
    }
    [returnArray addObjectsFromArray:otherArray];
    return returnArray;
}

+ (BOOL)isCNLanguage
{
    BOOL cn = NO;
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        cn = YES;
    }
    return cn;
}

+ (NSString *)handleString:(NSString *)string
{
    if (string) {
        return string;
    } else {
        return @"";
    }
}

+ (NSString *)getSexDes:(NSInteger)sex
{
    return sex == 0 ? NSLocalizedString(@"localized077", nil) : NSLocalizedString(@"localized076", nil);
}

+ (NSString *)getFileURLString:(NSString *)path
{
    path = [path stringByReplacingOccurrencesOfString:@"../" withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@%@", kFileURL, path];
    NSLog(@"%@", url);
    return url;
}

+ (void)setHeaderImageView:(UIImageView *)imageView path:(NSString *)path
{
    NSString * imagePath = path;
    if (imagePath){
        
        if ([imagePath rangeOfString:@"https://"].location != NSNotFound
            || [imagePath rangeOfString:@"https://"].location != NSNotFound)  {
            NSString *url = imagePath;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"account-header-default"]];
            return;
        }

    }
    path = [path stringByReplacingOccurrencesOfString:@"../" withString:@""];
    NSString *url = [Constants getFileURLString:path];
    
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"account-header-default"]];
}

+ (void)setImageView:(UIImageView *)imageView path:(NSString *)path
{
    NSString *url = [Constants getSmallImageURLString:path];
    
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

+ (NSString *)getSmallImageURLString:(NSString *)path
{
    path = [path stringByReplacingOccurrencesOfString:@"../" withString:@""];
    NSString *thumnial = path;
    NSArray *array = [path componentsSeparatedByString:@"."];
    if (array.count == 2) {
        thumnial = [NSString stringWithFormat:@"%@-small.%@", [array firstObject], [array lastObject]];
    }
    NSString *url = [Constants getFileURLString:thumnial];
    return url;
}

+ (UIButton *)createButton:(CGRect)frame title:(NSString *)title target:(id)target sel:(SEL)sel color:(UIColor *)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.5;
    button.layer.masksToBounds = YES;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [Constants setPublicButtonColor:color button:button];
    return button;
}

+ (void)setPublicButtonColor:(UIColor *)color button:(UIButton *)button
{
    button.layer.borderColor = color.CGColor;
    [button setTitleColor:color forState:UIControlStateNormal];
}

+ (NSString *)getLocalizedCountry:(NSString *)code
{
    NSString *countryString = @"";
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"plist"]];
    NSArray *countries = [CountryModel arrayOfModelsFromDictionaries:dicArray];
    for (CountryModel *model in countries) {
        if ([model.key isEqualToString:code]) {
            countryString = [Constants isCNLanguage] ? model.cn : model.en;
            break;
        }
    }
    return countryString;
}

+ (void)showTipsMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"localized012", nil)
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

@end
