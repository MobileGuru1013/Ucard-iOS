//
//  AccountSendModel.h
//  Ucard
//
//  Created by Conner Wu on 15/5/7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "JSONModel.h"

@interface AccountSendModel : JSONModel

@property (nonatomic, strong) NSString *postcard_id;
@property (nonatomic, strong) NSString *postcard_head;
@property (nonatomic, strong) UIImage * photoImage;

@end
