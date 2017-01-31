//
//  AddressPopView.h
//  Ucard
//
//  Created by WuLeilei on 15/4/24.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CardBasePopView.h"
#import "CountryModel.h"

@interface AddressPopView : CardBasePopView

@property (nonatomic, strong) CountryModel *countryModel;

@property (nonatomic, strong) void (^showCountryBlock) ();


@end
