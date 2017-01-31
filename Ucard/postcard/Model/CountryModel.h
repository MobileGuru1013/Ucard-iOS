//
//  CountryModel.h
//  Ucard
//
//  Created by Conner Wu on 15/4/28.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"

@interface CountryModel : BaseModel

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *en;
@property (nonatomic, strong) NSString *cn;

@end
