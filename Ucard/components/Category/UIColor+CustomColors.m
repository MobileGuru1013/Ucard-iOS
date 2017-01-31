//
//  UIColor+CustomColors.m
//  BusyBodyCustomer
//
//  Created by Mac on 8/28/15.
//  Copyright (c) 2015 Duong. All rights reserved.
//

#import "UIColor+CustomColors.h"
@implementation UIColor (CustomColors)

+(UIColor *) mygreenColor {
    return [UIColor colorWithRed:102.0/255.0 green:201.0/255.0 blue:144/255.0 alpha:1.0];
}



+(UIColor *) bg_wellnessclr { return [UIColor colorWithRed:8.0/255.0 green:36.0/255.0 blue:45.0/255.0 alpha:1.0]; }
+(UIColor *) line_wellnessclr { return [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:178.0/255.0 alpha:1.0]; }
+(UIColor *) bg_fitnessclr { return [UIColor colorWithRed:36.0/255.0 green:47.0/255.0 blue:21.0/255.0 alpha:1.0]; }
+(UIColor *) line_fitnessclr { return [UIColor colorWithRed:145.0/255.0 green:189.0/255.0 blue:85.0/255.0 alpha:1.0]; }
+(UIColor *) bg_sportclr { return [UIColor colorWithRed:64.0/255.0 green:34.0/255.0 blue:0 alpha:1.0]; }
+(UIColor *) line_sportclr { return [UIColor colorWithRed:255.0/255.0 green:135.0/255.0 blue:0 alpha:1.0]; }
+(UIColor *) bg_beautyclr { return [UIColor colorWithRed:38.0/255.0 green:48.0/255.0 blue:58.0/255.0 alpha:1.0]; }
+(UIColor *) line_beautyclr { return [UIColor colorWithRed:153.0/255.0 green:193.0/255.0 blue:233.0/255.0 alpha:1.0]; }
+(UIColor *) bg_retreatsclr { return [UIColor colorWithRed:5.0/255.0 green:25.0/255.0 blue:21.0/255.0 alpha:1.0]; }
+(UIColor *) line_retreatsclr { return [UIColor colorWithRed:18.0/255.0 green:101.0/255.0 blue:83.0/255.0 alpha:1.0]; }
+(UIColor *) bg_restaurantsclr { return [UIColor colorWithRed:56.0/255.0 green:23.0/255.0 blue:31.0/255.0 alpha:1.0]; }
+(UIColor *) line_restaurantsclr { return [UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:125.0/255.0 alpha:1.0]; }
+(UIColor *) bg_supplementsclr { return [UIColor colorWithRed:16.0/255.0 green:39.0/255.0 blue:0 alpha:1.0]; }
+(UIColor *) line_supplementsclr { return [UIColor colorWithRed:64.0/255.0 green:154.0/255.0 blue:0 alpha:1.0]; }
+(UIColor *) bg_luxuryclr { return [UIColor colorWithRed:50.0/255.0 green:47.0/255.0 blue:37.0/255.0 alpha:1.0]; }
+(UIColor *) line_luxuryclr { return [UIColor colorWithRed:199.0/255.0 green:187.0/255.0 blue:147.0/255.0 alpha:1.0]; }
+(UIColor *) bg_alldealsclr { return [UIColor colorWithRed:60.0/255.0 green:12.0/255.0 blue:10.0/255.0 alpha:1.0]; }
+(UIColor *) line_alldealsclr { return [UIColor colorWithRed:241.0/255.0 green:46.0/255.0 blue:38.0/255.0 alpha:1.0]; }

+(UIColor*) bg_tabUnselect{
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}
+(UIColor*) grayButton{
        return [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
}
+(UIColor*) accountBG{
    return [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
}
+(UIColor*) grayStep{
    return [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
}
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
