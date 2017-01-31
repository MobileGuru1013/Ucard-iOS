//
//  PayModel.h
//  Ucard
//
//  Created by WuLeilei on 15/5/19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject

@property(nonatomic, strong) NSString *paypalPath;
@property(nonatomic, assign) float showPrice;
@property(nonatomic, assign) float realPrice;
@property(nonatomic, strong) NSString *unit;

@end
