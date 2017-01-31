//
//  UserInfoModel.h
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *middle_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *house_number;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *county;
@property (nonatomic, strong) NSString *postcode;
@property (nonatomic, strong) NSString *third_party_uid;
@property (nonatomic, strong) NSString *date_of_birth;
@property (nonatomic, strong) NSString *register_type;
@property (nonatomic, strong) NSString *email;

@end
