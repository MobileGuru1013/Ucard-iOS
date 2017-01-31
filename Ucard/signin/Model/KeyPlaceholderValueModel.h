//
//  KeyPlaceholderValueModel.h
//  Ucard
//
//  Created by Conner Wu on 15-4-8.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"

@interface KeyPlaceholderValueModel : BaseModel

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *value;

@end
