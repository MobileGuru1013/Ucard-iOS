//
//  ReceiveCardModel.h
//  Ucard
//
//  Created by Conner Wu on 15/5/8.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"

@interface SearchCardModel : BaseModel

@property (nonatomic, strong) NSString *postcard_id;
@property (nonatomic, strong) NSString *postcard_head;
@property (nonatomic, strong) NSString *postcard_back;
@property (nonatomic, strong) NSString *sender_icon;
@property (nonatomic, strong) NSString *sender_nickname;
@property (nonatomic, strong) NSString *postcard_making_time;
@property (nonatomic, strong) NSString *receiver_country;
@property (nonatomic, assign) NSInteger sharing_state;

@end
