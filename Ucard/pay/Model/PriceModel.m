//
//  PriceModel.m
//  Ucard
//
//  Created by WuLeilei on 15/5/18.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PriceModel.h"

@implementation PriceModel

+ (PayModel *)getPrice:(NSString *)originalCountry
    destinationCountry:(NSString *)destinationCountry
               payType:(NSString *)payType
{
    NSArray *array = @[@{@"originalCountry": @"IE", @"destinationCountry": @"IE", @"paypalPath": @"paypal-IE-IE.php",
                         @"alipayShowPrice": @"16.03", @"alipayRealPrice": @"16.03", @"alipayUnit": [Constants isCNLanguage] ? @"人民币" : @"RMB",
                         @"paypalShowPrice": @"2.29", @"paypalRealPrice": @"2.29", @"paypalUnit": [Constants isCNLanguage] ? @"欧元" : @"EUR",
                         @"paymillShowPrice": @"2.29", @"paymillRealPrice": @"2.29", @"paymillUnit": [Constants isCNLanguage] ? @"欧元" : @"EUR"},
                       @{@"originalCountry": @"IE", @"destinationCountry": @"Other", @"paypalPath": @"paypal-IE-OTR.php",
                         @"alipayShowPrice": @"20.93", @"alipayRealPrice": @"20.93", @"alipayUnit": [Constants isCNLanguage] ? @"人民币" : @"RMB",
                         @"paypalShowPrice": @"2.99", @"paypalRealPrice": @"2.99", @"paypalUnit": [Constants isCNLanguage] ? @"欧元" : @"EUR",
                         @"paymillShowPrice": @"2.99", @"paymillRealPrice": @"2.99", @"paymillUnit": [Constants isCNLanguage] ? @"欧元" : @"EUR"},
                       @{@"originalCountry": @"GB", @"destinationCountry": @"GB", @"paypalPath": @"paypal-UK-UK.php",
#warning Test
                         @"alipayShowPrice": @"0.01", @"alipayRealPrice": @"0.01", @"alipayUnit": [Constants isCNLanguage] ? @"人民币" : @"RMB",
//                         @"alipayShowPrice": @"18.13", @"alipayRealPrice": @"18.13", @"alipayUnit": [Constants isCNLanguage] ? @"人民币" : @"RMB",
                         @"paypalShowPrice": @"0.01", @"paypalRealPrice": @"0.01", @"paypalUnit": [Constants isCNLanguage] ? @"英镑" : @"GBP",
//                         @"paypalShowPrice": @"1.99", @"paypalRealPrice": @"2.59", @"paypalUnit": [Constants isCNLanguage] ? @"英镑" : @"GBP",
                         @"paymillShowPrice": @"1.99", @"paymillRealPrice": @"2.59", @"paymillUnit": [Constants isCNLanguage] ? @"英镑" : @"GBP"},
                       @{@"originalCountry": @"GB", @"destinationCountry": @"Other", @"paypalPath": @"paypal-UK-OTR.php",
#warning Test
                         @"alipayShowPrice": @"0.01", @"alipayRealPrice": @"0.01", @"alipayUnit": [Constants isCNLanguage] ? @"人民币" : @"RMB",
//                         @"alipayShowPrice": @"16.03", @"alipayRealPrice": @"16.03", @"alipayUnit": [Constants isCNLanguage] ? @"人民币" : @"RMB",
                         @"paypalShowPrice": @"0.01", @"paypalRealPrice": @"0.01", @"paypalUnit": [Constants isCNLanguage] ? @"英镑" : @"GBP",
//                         @"paypalShowPrice": @"2.29", @"paypalRealPrice": @"2.89", @"paypalUnit": [Constants isCNLanguage] ? @"英镑" : @"GBP",
                         @"paymillShowPrice": @"2.29", @"paymillRealPrice": @"2.89", @"paymillUnit": [Constants isCNLanguage] ? @"英镑" : @"GBP"},
                       @{@"originalCountry": @"CN", @"destinationCountry": @"CN", @"paypalPath": @"paypal-CN-CN.php",
                         @"alipayShowPrice": @"6.99", @"alipayRealPrice": @"6.99", @"alipayUnit": [Constants isCNLanguage] ? @"人民币" : @"RMB",
                         @"paypalShowPrice": @"1.00", @"paypalRealPrice": @"1.00", @"paypalUnit": [Constants isCNLanguage] ? @"欧元" : @"EUR",
                         @"paymillShowPrice": @"1.00", @"paymillRealPrice": @"1.00", @"paymillUnit": [Constants isCNLanguage] ? @"欧元" : @"EUR"},
                       @{@"originalCountry": @"CN", @"destinationCountry": @"Other", @"paypalPath": @"paypal-CN-OTR.php",
                         @"alipayShowPrice": @"14.99", @"alipayRealPrice": @"14.99", @"alipayUnit": [Constants isCNLanguage] ? @"人民币" : @"RMB",
                         @"paypalShowPrice": @"2.14", @"paypalRealPrice": @"2.14", @"paypalUnit": [Constants isCNLanguage] ? @"欧元" : @"EUR",
                         @"paymillShowPrice": @"2.14", @"paymillRealPrice": @"2.14", @"paymillUnit": [Constants isCNLanguage] ? @"欧元" : @"EUR"}];
    array = [PriceModel arrayOfModelsFromDictionaries:array];
    
    PriceModel *price;
    for (PriceModel *model in array) {
        if ([model.originalCountry isEqualToString:originalCountry]) { // 找到打印国家
            if ([originalCountry isEqualToString:destinationCountry]) { // 国内
                if ([model.destinationCountry isEqualToString:originalCountry]) {
                    price = model;
                    break;
                }
            } else {
                if (![model.destinationCountry isEqualToString:originalCountry]) {
                    price = model;
                    break;
                }
            }
        }
    }
    
    PayModel *pay;
    if (price) {
        pay = [[PayModel alloc] init];
        pay.paypalPath = price.paypalPath;
        if ([payType isEqualToString:@"alipay"]) {
            pay.showPrice = price.alipayShowPrice;
            pay.realPrice = price.alipayRealPrice;
            pay.unit = price.alipayUnit;
        } else if ([payType isEqualToString:@"paypal"]) {
            pay.showPrice = price.paypalShowPrice;
            pay.realPrice = price.paypalRealPrice;
            pay.unit = price.paypalUnit;
        } else if ([payType isEqualToString:@"paymill"]) {
            pay.showPrice = price.paymillShowPrice;
            pay.realPrice = price.paymillRealPrice;
            pay.unit = price.paymillUnit;
        }
    }
    
    return pay;
}

@end
