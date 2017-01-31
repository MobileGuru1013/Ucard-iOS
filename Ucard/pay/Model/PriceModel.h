//
//  PriceModel.h
//  Ucard
//
//  Created by WuLeilei on 15/5/18.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"
#import "PayModel.h"

@interface PriceModel : BaseModel

@property(nonatomic, strong) NSString *originalCountry;
@property(nonatomic, strong) NSString *destinationCountry;
@property(nonatomic, strong) NSString *paypalPath;
@property(nonatomic, assign) float alipayShowPrice;
@property(nonatomic, assign) float alipayRealPrice;
@property(nonatomic, strong) NSString *alipayUnit;
@property(nonatomic, assign) float paypalShowPrice;
@property(nonatomic, assign) float paypalRealPrice;
@property(nonatomic, strong) NSString *paypalUnit;
@property(nonatomic, assign) float paymillShowPrice;
@property(nonatomic, assign) float paymillRealPrice;
@property(nonatomic, strong) NSString *paymillUnit;

+ (PayModel *)getPrice:(NSString *)originalCountry
    destinationCountry:(NSString *)destinationCountry
               payType:(NSString *)payType;

@end
