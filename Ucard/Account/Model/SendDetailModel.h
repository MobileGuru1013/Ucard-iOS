//
//  SendDetailModel.h
//  Ucard
//
//  Created by Conner Wu on 15/5/9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"

@interface SendDetailModel : BaseModel

@property (nonatomic, strong) NSString *postcard_id;
@property (nonatomic, strong) NSString *postcard_head;
@property (nonatomic, strong) NSString *postcard_back;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *payment_type;
@property (nonatomic, strong) NSString *record_uid;
@property (nonatomic, strong) NSString *postcard_making_time;
@property (nonatomic, strong) NSString *original_country;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) NSInteger sharing_state;

@end
